local M = {}

local presets = {
  { name = "codex", command = "codex" },
  { name = "cursor-agent", command = "cursor-agent" },
  { name = "opencode", command = "opencode" },
}

local state = {
  last_pane = nil,
}

local function system_ok(cmd, input)
  local output = vim.fn.system(cmd, input)
  if vim.v.shell_error ~= 0 then
    return nil, output
  end
  return output, nil
end

local function in_tmux()
  return os.getenv("TMUX") ~= nil
end

local function get_panes()
  local lines = vim.fn.systemlist({
    "tmux",
    "list-panes",
    "-a",
    "-F",
    "#{pane_id}\t#{session_name}:#{window_index}.#{pane_index}\t#{window_name}\t#{pane_current_command}",
  })

  if vim.v.shell_error ~= 0 then
    return {}
  end

  local panes = {}
  for _, line in ipairs(lines) do
    local parts = vim.split(line, "\t")
    if #parts >= 4 then
      table.insert(panes, {
        id = parts[1],
        target = parts[2],
        window_name = parts[3],
        current_command = parts[4],
      })
    end
  end

  return panes
end

local function pane_exists(pane_id)
  for _, pane in ipairs(get_panes()) do
    if pane.id == pane_id then
      return true
    end
  end
  return false
end

local function pick_pane(callback)
  local panes = get_panes()
  if #panes == 0 then
    vim.notify("No tmux panes found", vim.log.levels.ERROR)
    return
  end

  vim.ui.select(panes, {
    prompt = "Select tmux pane",
    format_item = function(item)
      return string.format("%s [%s] (%s)", item.target, item.window_name, item.current_command)
    end,
  }, function(choice)
    if choice then
      callback(choice.id)
    end
  end)
end

local function find_preset(name)
  for _, preset in ipairs(presets) do
    if preset.name == name then
      return preset
    end
  end
  return nil
end

local function start_command(command)
  if not in_tmux() then
    vim.notify("Start Neovim inside tmux to split panes", vim.log.levels.ERROR)
    return
  end

  local pane_id, err = system_ok({
    "tmux",
    "split-window",
    "-h",
    "-p",
    "20",
    "-c",
    vim.fn.getcwd(),
    "-P",
    "-F",
    "#{pane_id}",
    command,
  })

  if not pane_id then
    vim.notify("Failed to start command in tmux: " .. (err or ""), vim.log.levels.ERROR)
    return
  end

  state.last_pane = vim.trim(pane_id)
  vim.notify("Started in pane " .. state.last_pane, vim.log.levels.INFO)
end

local function build_payload(line1, line2)
  local lines = vim.api.nvim_buf_get_lines(0, line1 - 1, line2, false)
  local text = table.concat(lines, "\n")
  local file = vim.api.nvim_buf_get_name(0)

  if file == "" then
    return text
  end

  local rel = vim.fn.fnamemodify(file, ":.")
  local header = string.format("File: %s:%d-%d\n\n", rel, line1, line2)
  return header .. text
end

local function send_to_pane(pane_id, text)
  local _, err1 = system_ok({ "tmux", "load-buffer", "-" }, text)
  if err1 then
    vim.notify("tmux load-buffer failed: " .. err1, vim.log.levels.ERROR)
    return
  end

  local _, err2 = system_ok({ "tmux", "paste-buffer", "-d", "-t", pane_id })
  if err2 then
    vim.notify("tmux paste-buffer failed: " .. err2, vim.log.levels.ERROR)
    return
  end

  local _, err3 = system_ok({ "tmux", "select-pane", "-t", pane_id })
  if err3 then
    vim.notify("tmux select-pane failed: " .. err3, vim.log.levels.ERROR)
    return
  end

  state.last_pane = pane_id
  vim.notify("Sent selection to " .. pane_id, vim.log.levels.INFO)
end

local function resolve_target_pane(explicit_pane, callback)
  if explicit_pane and explicit_pane ~= "" then
    callback(explicit_pane)
    return
  end

  if state.last_pane and pane_exists(state.last_pane) then
    callback(state.last_pane)
    return
  end

  pick_pane(callback)
end

vim.api.nvim_create_user_command("AITmuxStart", function(opts)
  if opts.args ~= "" then
    local preset = find_preset(opts.args)
    if preset then
      start_command(preset.command)
      return
    end

    start_command(opts.args)
    return
  end

  vim.ui.select(presets, {
    prompt = "Start AI TUI in tmux",
    format_item = function(item)
      return string.format("%s (%s)", item.name, item.command)
    end,
  }, function(choice)
    if choice then
      start_command(choice.command)
    end
  end)
end, {
  nargs = "?",
  complete = function()
    local names = {}
    for _, preset in ipairs(presets) do
      table.insert(names, preset.name)
    end
    return names
  end,
  desc = "Start AI TUI in a new tmux pane",
})

vim.api.nvim_create_user_command("AITmuxSend", function(opts)
  if not in_tmux() then
    vim.notify("Start Neovim inside tmux first", vim.log.levels.ERROR)
    return
  end

  local line1 = opts.line1
  local line2 = opts.line2
  local payload = build_payload(line1, line2)

  resolve_target_pane(opts.args, function(pane_id)
    send_to_pane(pane_id, payload)
  end)
end, {
  nargs = "?",
  range = true,
  desc = "Send selected lines to a tmux pane with filename context",
})

vim.api.nvim_create_user_command("AITmuxPane", function()
  pick_pane(function(pane_id)
    state.last_pane = pane_id
    vim.notify("Default AI pane set to " .. pane_id, vim.log.levels.INFO)
  end)
end, {
  desc = "Pick default tmux pane for AI send",
})

vim.keymap.set("n", "<leader>a", "<cmd>AITmuxStart<CR>", { silent = true, desc = "AI TUI start" })
vim.keymap.set("v", "<leader>as", "<cmd>AITmuxSend<CR>", { silent = true, desc = "AI send selection" })

return M
