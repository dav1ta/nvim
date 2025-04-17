local function run_python_command()
  local file_path = vim.fn.expand('%:p') -- Full path to the script
  local dir_path = vim.fn.expand('%:p:h') -- Directory containing the script
  local cmd = "cd " .. dir_path .. " && python " .. file_path
  return cmd
end


local function run_bash_command()
  local file_path = vim.fn.expand('%:p')
  local cmd = "bash " .. file_path
  return cmd
end

local function run_typescript_command()
  local file_path = vim.fn.expand('%:p')
  local cmd = "ts-node " .. file_path
  return cmd
end

local function run_command_for_filetype(filetype)
  if filetype == "python" then
    return run_python_command()
  elseif filetype == "sh" then
    return run_bash_command()
  elseif filetype == "typescript" then
    return run_typescript_command()
  else
    return nil
  end
end

function run_project(args)
  local Project = require('project_nvim.project')
  local project_root = Project.get_project_root(vim.fn.expand('%:p'))
  local filetype = vim.bo.filetype
  local make_cmd

  if project_root ~= nil then
    local makefile_path = project_root .. '/Makefile'
    if vim.fn.filereadable(makefile_path) ~= 1 then
      makefile_path = project_root .. '/makefile'
    end

    local docker_compose_path = project_root .. '/docker-compose.yml'
    local docker_compose_dev_path = project_root .. '/docker-compose-dev.yml'
    local npm_path = project_root .. '/package.json'
    local go_path = project_root .. '/go.mod'

    if vim.fn.filereadable(makefile_path) == 1 then
      make_cmd = "make -f " .. makefile_path
      if args ~= nil and args ~= '' then
        make_cmd = make_cmd .. ' ' .. args
      end
    elseif vim.fn.filereadable(docker_compose_dev_path) == 1 then
      make_cmd = "docker-compose -f " .. docker_compose_dev_path .. " up"
      if args ~= nil and args ~= '' then
        make_cmd = make_cmd .. ' ' .. args
      end
    elseif vim.fn.filereadable(docker_compose_path) == 1 then
      make_cmd = "docker-compose -f " .. docker_compose_path .. " up"
      if args ~= nil and args ~= '' then
        make_cmd = make_cmd .. ' ' .. args
      end
    elseif vim.fn.filereadable(npm_path) == 1 then
      make_cmd = "npm run"
      if args ~= nil and args ~= '' then
        make_cmd = make_cmd .. ' ' .. args
      end
    elseif vim.fn.filereadable(go_path) == 1 then
      make_cmd = "go run ."
      if args ~= nil and args ~= '' then
        make_cmd = make_cmd .. ' ' .. args
      end
    end
  end

  if make_cmd == nil then
    make_cmd = run_command_for_filetype(filetype)
    if make_cmd == nil then
      vim.cmd("echohl Error | echo 'No command found for filetype: " .. filetype .. "' | echohl None")
      return
    end
  end

  for _ = 1, 3 do
    vim.cmd("VimuxInterruptRunner")
  end
  vim.cmd("VimuxRunCommand 'cd " .. project_root .. " && " .. make_cmd .. "'")

  vim.fn.system(string.format("tmux select-window -t '%s'", 'vimuxout'))
end

vim.cmd("command! -nargs=* Ru lua run_project(<q-args>)")

local function trim(s)
  return s:gsub("^%s*(.-)%s*$", "%1")
end

function tmux_run(cmd_name, cmd)
  local window_id = trim(vim.fn.system(string.format("tmux list-windows -F '#{window_name} #{window_id}' | grep '^%s ' | awk '{print $2}'", cmd_name)))

  if window_id == "" then
    vim.fn.system(string.format("tmux new-window -n '%s' '%s'", cmd_name, cmd))
  else
    vim.fn.system(string.format("tmux select-window -t '%s'", window_id))
  end
end

vim.cmd("command! TmuxHtop lua _G.tmux_run('htop', 'htop')")
vim.cmd("command! LazyGit lua _G.tmux_run('lazygit', 'lazygit')")
vim.cmd("command! LazyDocker lua _G.tmux_run('lazydocker', 'lazydocker')")

_G.tmux_command = function(window_name, command)
  if os.getenv("TMUX") then
    local output = io.popen("tmux list-windows"):read("*all")

    if output:find(window_name) then
      vim.fn.system(string.format("tmux send-keys -t '%s' C-c C-l 'cd %s && %s' C-m", window_name, vim.fn.getcwd(), command))
    else
      vim.fn.system(string.format("tmux new-window -n '%s'", window_name))
      vim.fn.system(string.format("tmux send-keys -t '%s' 'cd %s && %s' C-m", window_name, vim.fn.getcwd(), command))
    end
    vim.fn.system(string.format("tmux select-window -t '%s'", window_name))
  end
end

vim.api.nvim_command("command! -nargs=+ RunTmux call luaeval('_G.tmux_command(_A)', <f-args>)")

local filename = vim.api.nvim_buf_get_name(0)
local profiling_cmd = 'cd ' .. vim.fn.getcwd() .. ' && python -m cProfile -o log.pst ' .. filename .. ' && gprof2dot -f pstats log.pst | dot -Tsvg -o log.svg && firefox log.svg'

vim.cmd("command! Profile call luaeval('_G.tmux_command(\"profile\", \"" .. profiling_cmd .. "\")')")




