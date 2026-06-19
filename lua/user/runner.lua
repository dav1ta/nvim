local uv = vim.uv
local tmux = require('user.tmux')

local M = {}

---@class RunnerState
---@field last_run? RunnerResult
---@field custom_history string
---@field env_prompt_history table<string, table<string,string>>
local state = {
  env_prompt_history = {},
}

---@class RunnerContext
---@field file string
---@field filetype string
---@field extension string
---@field cwd string
---@field project_root string
---@field relative_file string

---@class RunnerRuntime
---@field argline string
---@field tokens string[]
---@field args string
---@field requested_alias? string

---@class RunnerResult
---@field name string
---@field cmd string
---@field cwd string
---@field env table<string, string>

local path_sep = package.config:sub(1, 1)

local function trim(s)
  return (s:gsub('^%s+', ''):gsub('%s+$', ''))
end

local function file_exists(path)
  if not path or path == '' then
    return false
  end
  local stat = uv.fs_stat(path)
  return stat ~= nil
end

local function join_paths(...)
  local parts = { ... }
  local result = table.concat(parts, path_sep)
  result = result:gsub(path_sep .. path_sep, path_sep)
  return result
end

local function read_file(path)
  local ok, data = pcall(vim.fn.readfile, path)
  if not ok then
    return nil
  end
  return table.concat(data, '\n')
end

-- Best-effort JSONC to JSON: strips // and /* */ comments, and trailing commas
local function jsonc_to_json(s)
  if type(s) ~= 'string' then
    return s
  end
  -- strip block comments
  s = s:gsub('/%*.-%*/', '')
  -- strip line comments
  s = s:gsub('[ \t]*//[^\n]*', '')
  -- remove trailing commas before } or ]
  s = s:gsub(',%s*([}%]])', '%1')
  return s
end

local function format_env(env)
  local assignments = {}
  for key, value in pairs(env) do
    table.insert(assignments, string.format('%s=%s', key, vim.fn.shellescape(value)))
  end
  table.sort(assignments)
  if #assignments == 0 then
    return ''
  end
  return table.concat(assignments, ' ') .. ' '
end

local function relpath(path, start)
  if not start or start == '' then
    return path
  end
  local ok, result = pcall(vim.fs.relpath, path, start)
  if ok and result then
    return result
  end
  -- fallback: try fnamemodify relative to cwd
  return vim.fn.fnamemodify(path, ':~')
end

local function gather_context()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  local filetype = vim.bo[buf].filetype or ''
  local extension = vim.fn.fnamemodify(file, ':e')
  local cwd = vim.uv.cwd()

  local project_root = require("user.utils").find_project_root(file ~= "" and file or cwd)

  local relative_file = relpath(file, project_root)

  return {
    file = file,
    filetype = filetype,
    extension = extension,
    cwd = cwd,
    project_root = project_root,
    relative_file = relative_file,
  }
end

---@param result RunnerResult
local function store_last_run(result)
  state.last_run = vim.deepcopy(result)
end

-- Resolve prompted env values defined in config via special marker values.
-- Any env value beginning with '?' will trigger a prompt. The part after
-- '?' is treated as the default. Example: { AMOUNT = '?10' } prompts with default 10.
local function resolve_prompted_env(entry_name, env)
  local out = {}
  for k, v in pairs(env or {}) do
    if type(v) == 'string' and v:sub(1,1) == '?' then
      local default = v:sub(2)
      state.env_prompt_history[entry_name] = state.env_prompt_history[entry_name] or {}
      local hist_default = state.env_prompt_history[entry_name][k]
      local prompt_default = hist_default ~= nil and hist_default or default or ''
      local answer = vim.fn.input(string.format('%s: ', k), prompt_default)
      if answer == '' then
        answer = prompt_default
      end
      out[k] = answer
      state.env_prompt_history[entry_name][k] = answer
    else
      out[k] = v
    end
  end
  return out
end

local function run_in_tmux(result)
  local cwd = result.cwd or vim.uv.cwd()
  local env_prefix = format_env(result.env or {})
  local cd_cmd = string.format('cd %s', vim.fn.shellescape(cwd))
  local full = string.format('%s && %s%s', cd_cmd, env_prefix, result.cmd)

  -- Ensure runner pane/window exists
  pcall(vim.cmd, 'silent! VimuxOpenRunner')

  for _ = 1, 3 do
    pcall(vim.cmd, 'silent! VimuxInterruptRunner')
  end

  local quoted = vim.fn.shellescape(full)
  pcall(vim.cmd, string.format('silent! VimuxRunCommand %s', quoted))

  tmux.select_window('vimuxout')
end

---@param raw string
local function split_tokens(raw)
  local tokens = {}
  if not raw or raw == '' then
    return tokens
  end
  for token in raw:gmatch('%S+') do
    table.insert(tokens, token)
  end
  return tokens
end

local function command_label(entry)
  if entry.description and entry.description ~= '' then
    return string.format('%s → %s', entry.name, entry.description)
  end
  return entry.name
end

local function build_runtime(argline)
  local runtime = {
    argline = argline or '',
  }
  runtime.tokens = split_tokens(runtime.argline)
  runtime.args = ''
  return runtime
end

local function build_python_commands(ctx, add)
  local file_is_python = ctx.filetype == 'python' or ctx.extension == 'py'
  local project_has_python = file_exists(join_paths(ctx.project_root, 'pyproject.toml'))
    or file_exists(join_paths(ctx.project_root, 'Pipfile'))
    or file_exists(join_paths(ctx.project_root, 'requirements.txt'))
    or file_exists(join_paths(ctx.project_root, 'poetry.lock'))
    or file_exists(join_paths(ctx.project_root, '.python-version'))

  if not file_is_python and not project_has_python then
    return
  end

  local added_default_alias = false
  local seen_cmd = {}

  local function add_python(label, command, priority)
    if not command or command == '' then
      return
    end
    if seen_cmd[command] then
      return
    end
    add({
      name = string.format('Python › %s', label),
      description = command,
      aliases = not added_default_alias and { 'python', 'py' } or nil,
      priority = priority,
      supports_env = true,
      build = function()
        local binary = command
        if not binary:match('%s') then
          binary = vim.fn.shellescape(binary)
        end
        local cmd = string.format('%s %s', binary, vim.fn.shellescape(ctx.file))
        return {
          name = string.format('Python › %s', label),
          cmd = cmd,
          cwd = ctx.project_root,
          env = {},
        }
      end,
    })
    added_default_alias = true
    seen_cmd[command] = true
  end

  -- Local virtualenvs in project
  local potential = {
    { label = '.venv', path = '.venv/bin/python', priority = 210 },
    { label = 'venv', path = 'venv/bin/python', priority = 200 },
    { label = 'env', path = 'env/bin/python', priority = 190 },
    { label = 'virtualenv', path = '.virtualenv/bin/python', priority = 180 },
  }
  for _, item in ipairs(potential) do
    local abs = join_paths(ctx.project_root, item.path)
    if file_exists(abs) then
      add_python(item.label, abs, item.priority)
    end
  end

  -- Currently active venv
  local active_venv = os.getenv('VIRTUAL_ENV')
  if active_venv then
    local active_py = join_paths(active_venv, 'bin/python')
    if file_exists(active_py) then
      add_python('active-venv', active_py, 175)
    end
  end

  -- Tool-based runners
  if file_exists(join_paths(ctx.project_root, 'poetry.lock')) then
    add_python('poetry', 'poetry run python', 170)
  end

  if file_exists(join_paths(ctx.project_root, 'Pipfile')) then
    add_python('pipenv', 'pipenv run python', 165)
  end

  if file_exists(join_paths(ctx.project_root, 'uv.lock')) or file_exists(join_paths(ctx.project_root, 'uv.toml')) then
    add_python('uv', 'uv run python', 160)
  end

  -- System interpreters (only add if executable)
  if vim.fn.executable('python3') == 1 then
    add_python('python3', 'python3', 120)
  end
  if vim.fn.executable('python') == 1 then
    add_python('system', 'python', 110)
  end
end

local function build_make_commands(ctx, add)
  local makefile = nil
  local candidates = { 'Makefile', 'makefile' }
  for _, candidate in ipairs(candidates) do
    local full = join_paths(ctx.project_root, candidate)
    if file_exists(full) then
      makefile = full
      break
    end
  end

  if not makefile then
    return
  end

  add({
    name = 'Make',
    aliases = { 'make' },
    priority = 150,
    build = function(_, runtime)
      local cmd = 'make'
      if runtime.args and runtime.args ~= '' then
        cmd = cmd .. ' ' .. runtime.args
      end
      return {
        name = 'Make',
        cmd = cmd,
        cwd = ctx.project_root,
        env = {},
      }
    end,
  })

  add({
    name = 'Make target…',
    priority = 145,
    build = function()
      local target = trim(vim.fn.input('make target: '))
      if target == '' then
        return nil
      end
      return {
        name = 'Make target…',
        cmd = 'make ' .. target,
        cwd = ctx.project_root,
        env = {},
      }
    end,
  })
end

local function build_docker_commands(ctx, add)
  local compose_dev = join_paths(ctx.project_root, 'docker-compose-dev.yml')
  local compose = join_paths(ctx.project_root, 'docker-compose.yml')
  local compose_file = nil
  if file_exists(compose_dev) then
    compose_file = compose_dev
  elseif file_exists(compose) then
    compose_file = compose
  end

  if not compose_file then
    return
  end

  add({
    name = 'Docker Compose up',
    aliases = { 'compose' },
    priority = 140,
    build = function(_, runtime)
      local cmd = string.format('docker compose -f %s up', vim.fn.shellescape(compose_file))
      if runtime.args and runtime.args ~= '' then
        cmd = cmd .. ' ' .. runtime.args
      end
      return {
        name = 'Docker Compose up',
        cmd = cmd,
        cwd = ctx.project_root,
        env = {},
      }
    end,
  })

  add({
    name = 'Docker Compose down',
    priority = 135,
    build = function()
      local cmd = string.format('docker compose -f %s down', vim.fn.shellescape(compose_file))
      return {
        name = 'Docker Compose down',
        cmd = cmd,
        cwd = ctx.project_root,
        env = {},
      }
    end,
  })
end

local function build_npm_commands(ctx, add)
  local package_json = join_paths(ctx.project_root, 'package.json')
  if not file_exists(package_json) then
    return
  end

  local content = read_file(package_json)
  if not content then
    return
  end

  local ok, parsed = pcall(vim.fn.json_decode, content)
  if not ok or type(parsed) ~= 'table' then
    return
  end

  local scripts = parsed.scripts
  if type(scripts) ~= 'table' then
    return
  end

  for name, _ in pairs(scripts) do
    add({
      name = 'npm run ' .. name,
      aliases = { 'npm:' .. name },
      priority = 130,
      build = function(_, runtime)
        local base = string.format('npm run %s', vim.fn.shellescape(name))
        if runtime.args and runtime.args ~= '' then
          base = string.format('%s -- %s', base, runtime.args)
        end
        return {
          name = 'npm run ' .. name,
          cmd = base,
          cwd = ctx.project_root,
          env = {},
        }
      end,
    })
  end
end

local function build_go_commands(ctx, add)
  local go_mod = join_paths(ctx.project_root, 'go.mod')
  if not file_exists(go_mod) then
    return
  end

  add({
    name = 'Go run',
    aliases = { 'go' },
    priority = 125,
    build = function(_, runtime)
      local cmd = 'go run .'
      if runtime.args and runtime.args ~= '' then
        cmd = 'go run ' .. runtime.args
      end
      return {
        name = 'Go run',
        cmd = cmd,
        cwd = ctx.project_root,
        env = {},
      }
    end,
  })

  add({
    name = 'Go test ./...',
    priority = 120,
    build = function()
      return {
        name = 'Go test ./...',
        cmd = 'go test ./...',
        cwd = ctx.project_root,
        env = {},
      }
    end,
  })
end

local function build_custom_command(add)
  add({
    name = 'Ad-hoc shell command…',
    aliases = { '!' },
    priority = 50,
    supports_env = true,
    build = function(context, runtime)
      local default = runtime.argline ~= '' and runtime.argline or state.custom_history or ''
      local input = trim(vim.fn.input('Shell command: ', default))
      if input == '' then
        return nil
      end
      state.custom_history = input
      return {
        name = 'Ad-hoc shell command…',
        cmd = input,
        cwd = context.project_root,
        env = {},
      }
    end,
  })
end

local function project_config_exists(root)
  local dir = join_paths(root, '.nvim')
  return file_exists(join_paths(dir, 'run.jsonc')) or file_exists(join_paths(dir, 'run.json'))
end

local project_config_path
local substitute_vars
local build_config_commands

local function collect_commands(ctx)
  local commands = {}
  local alias_map = {}

  local function add(entry)
    if not entry or not entry.name then
      return
    end
    entry.priority = entry.priority or 0
    table.insert(commands, entry)
    if entry.aliases then
      for _, alias in ipairs(entry.aliases) do
        local key = alias:lower()
        if alias_map[key] == nil then
          alias_map[key] = entry
        end
      end
    end
  end

  if state.last_run then
    local last = state.last_run
    add({
      name = '⟳ ' .. (last.name or last.cmd),
      aliases = { 'last' },
      priority = 1000,
      build = function()
        return vim.deepcopy(last)
      end,
    })
  end

  local had_config = false
  -- Load project-defined run entries from .nvim/run.json(.jsonc)
  if type(build_config_commands) == 'function' then
    local ok, res = pcall(build_config_commands, ctx, add)
    if ok and res then
      had_config = true
    end
  end

  -- If a config exists, prefer only config-defined entries.
  if not had_config and not project_config_exists(ctx.project_root) then
    build_python_commands(ctx, add)
    build_make_commands(ctx, add)
    build_docker_commands(ctx, add)
    build_npm_commands(ctx, add)
    build_go_commands(ctx, add)
    build_custom_command(add)
  end

  table.sort(commands, function(a, b)
    local pa = a.priority or 0
    local pb = b.priority or 0
    if pa == pb then
      return a.name < b.name
    end
    return pa > pb
  end)

  return commands, alias_map
end

local function execute_entry(entry, ctx, runtime)
  local builder = entry.build or function()
    if entry.cmd then
      return {
        name = entry.name,
        cmd = entry.cmd,
        cwd = ctx.project_root,
        env = {},
      }
    end
  end

  local result = builder(ctx, runtime) or builder()
  if not result then
    return
  end

  -- Normalise result table in case builder returned string
  if type(result) == 'string' then
    result = {
      name = entry.name,
      cmd = result,
      cwd = ctx.project_root,
      env = {},
    }
  else
    result = vim.tbl_extend('force', {
      name = entry.name,
      cmd = '',
      cwd = ctx.project_root,
      env = {},
    }, result)
  end

  if result.cmd == '' then
    return
  end

  -- Only prompt for env keys explicitly marked in config with '?' marker
  result.env = resolve_prompted_env(entry.name, result.env)

  run_in_tmux(result)
  store_last_run(result)
end

local function run_raw_command(ctx, command)
  if not command or command == '' then
    return
  end
  local result = {
    name = command,
    cmd = command,
    cwd = ctx.project_root,
    env = {},
  }
  run_in_tmux(result)
  store_last_run(result)
end

function M.run(argline)
  local runtime = build_runtime(argline)
  local ctx = gather_context()
  local commands, alias_map = collect_commands(ctx)

  if runtime.tokens[1] then
    local alias = runtime.tokens[1]:lower()
    local entry = alias_map[alias]
    if entry then
      runtime.requested_alias = alias
      if #runtime.tokens > 1 then
        local pieces = {}
        for i = 2, #runtime.tokens do
          table.insert(pieces, runtime.tokens[i])
        end
        runtime.args = table.concat(pieces, ' ')
      end
      execute_entry(entry, ctx, runtime)
      return
    end

    -- No known alias: treat as raw command
    run_raw_command(ctx, runtime.argline)
    return
  end

  local items = {}
  for _, entry in ipairs(commands) do
    table.insert(items, entry)
  end

  if #items == 0 then
    vim.notify('No runner commands available for this project', vim.log.levels.WARN)
    return
  end

  vim.ui.select(items, {
    prompt = 'Run command',
    format_item = command_label,
  }, function(choice)
    if not choice then
      return
    end
    execute_entry(choice, ctx, runtime)
  end)
end

vim.api.nvim_create_user_command('Ru', function(opts)
  M.run(opts.args)
end, { nargs = '*', desc = 'Run project command via Vimux' })

-- Telescope-powered picker for run commands
function M.run_picker(argline)
  local ok_telescope = pcall(require, 'telescope')
  if not ok_telescope then
    vim.notify('telescope.nvim not available; falling back to :Ru', vim.log.levels.WARN)
    return M.run(argline)
  end

  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

  local runtime = build_runtime(argline)
  runtime.args = runtime.argline
  local ctx = gather_context()
  local commands = select(1, collect_commands(ctx))

  if not commands or #commands == 0 then
    vim.notify('No runner commands available for this project', vim.log.levels.WARN)
    return
  end

  local entries = {}
  for _, e in ipairs(commands) do
    table.insert(entries, e)
  end

  pickers.new({}, {
    prompt_title = 'Run command',
    finder = finders.new_table({
      results = entries,
      entry_maker = function(item)
        local display = command_label(item)
        return {
          value = item,
          display = display,
          ordinal = display:lower(),
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr, _)
      actions.select_default:replace(function()
        actions.close(prompt_bufnr)
        local selection = action_state.get_selected_entry()
        if selection and selection.value then
          execute_entry(selection.value, ctx, runtime)
        end
      end)
      return true
    end,
  }):find()
end

vim.api.nvim_create_user_command('RuPick', function(opts)
  M.run_picker(opts.args)
end, { nargs = '*', desc = 'Pick and run project command via Telescope' })

vim.api.nvim_create_user_command('RuLast', function()
  if not state.last_run then
    vim.notify('No command has been run yet', vim.log.levels.INFO)
    return
  end
  local ctx = gather_context()
  execute_entry({
    name = state.last_run.name or 'Last command',
    build = function()
      return vim.deepcopy(state.last_run)
    end,
  }, ctx, { argline = '', tokens = {}, args = '' })
end, { desc = 'Re-run last project command' })

-- Project config support (.nvim/run.json)
project_config_path = function(root)
  -- Prefer .jsonc, fallback to .json
  local dir = join_paths(root, '.nvim')
  local jsonc = join_paths(dir, 'run.jsonc')
  if file_exists(jsonc) then
    return jsonc
  end
  return join_paths(dir, 'run.json')
end

substitute_vars = function(s, ctx)
  if type(s) ~= 'string' then
    return s
  end
  local out = s
  out = out:gsub('%%{file}', vim.fn.shellescape(ctx.file))
  out = out:gsub('%%{relative_file}', vim.fn.shellescape(ctx.relative_file))
  out = out:gsub('%%{project_root}', vim.fn.shellescape(ctx.project_root))
  out = out:gsub('%%{cwd}', vim.fn.shellescape(ctx.cwd))
  return out
end

build_config_commands = function(ctx, add)
  local path = project_config_path(ctx.project_root)
  if not file_exists(path) then
    return false
  end
  local content = read_file(path)
  if not content or content == '' then
    return false
  end
  -- allow comments and trailing commas
  local ok, conf = pcall(vim.fn.json_decode, jsonc_to_json(content))
  if not ok or type(conf) ~= 'table' then
    vim.notify('Invalid JSON in ' .. path, vim.log.levels.ERROR)
    return false
  end
  local entries = conf.entries or conf
  if type(entries) ~= 'table' then
    return false
  end

  local added_any = false
  for _, e in ipairs(entries) do
    if type(e) == 'table' and type(e.name) == 'string' then
      local aliases = e.aliases or e.alias or nil
      add({
        name = e.name,
        description = e.description,
        aliases = aliases,
        priority = (e.priority or 800),
        supports_env = e.supports_env ~= false,
        build = function(_, runtime)
          local cmd
          if e.cmd and e.cmd ~= '' then
            cmd = substitute_vars(e.cmd, ctx)
            if runtime.args and runtime.args ~= '' then
              cmd = cmd .. ' ' .. runtime.args
            end
          else
            return nil
          end
          local env = {}
          if type(e.env) == 'table' then
            for k, v in pairs(e.env) do
              env[k] = tostring(substitute_vars(v, ctx))
            end
          end
          return {
            name = e.name,
            cmd = cmd,
            cwd = e.cwd and substitute_vars(e.cwd, ctx) or ctx.project_root,
            env = env,
          }
        end,
      })
      added_any = true
    end
  end
  return added_any
end

vim.api.nvim_create_user_command('TmuxHtop', function()
  tmux.open_or_select_window('htop', 'htop')
end, { desc = 'Open htop in a tmux window' })

vim.api.nvim_create_user_command('LazyGit', function()
  tmux.open_or_select_window('lazygit', 'lazygit')
end, { desc = 'Open lazygit in tmux' })

vim.api.nvim_create_user_command('LazyDocker', function()
  tmux.open_or_select_window('lazydocker', 'lazydocker')
end, { desc = 'Open lazydocker in tmux' })

vim.api.nvim_create_user_command('RunTmux', function(opts)
  local args = opts.fargs
  if #args < 2 then
    vim.notify('Usage: RunTmux <window> <command>', vim.log.levels.ERROR)
    return
  end
  local window_name = table.remove(args, 1)
  local command = table.concat(args, ' ')
  tmux.send_to_window(window_name, command)
end, { nargs = '+', desc = 'Send command to named tmux window' })

vim.api.nvim_create_user_command('Profile', function()
  local ctx = gather_context()
  if ctx.file == '' then
    vim.notify('Current buffer has no file on disk to profile', vim.log.levels.ERROR)
    return
  end
  local profiling_cmd = string.format(
    "cd %s && python -m cProfile -o log.pst %s && gprof2dot -f pstats log.pst | dot -Tsvg -o log.svg && firefox log.svg",
    vim.fn.shellescape(ctx.cwd),
    vim.fn.shellescape(ctx.file)
  )
  tmux.send_to_window('profile', profiling_cmd, { cwd = ctx.cwd })
end, { desc = 'Profile current Python file using cProfile' })

return M
