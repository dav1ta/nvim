local M = {}

local function trim(s)
  return (s:gsub('^%s+', ''):gsub('%s+$', ''))
end

local function in_tmux()
  return os.getenv('TMUX') ~= nil
end

local function tmux(args)
  return vim.fn.system(vim.list_extend({ 'tmux' }, args))
end

local function tmux_list(args)
  return vim.fn.systemlist(vim.list_extend({ 'tmux' }, args))
end

function M.select_window(window_name)
  return tmux({ 'select-window', '-t', window_name })
end

function M.open_or_select_window(window_name, command)
  local windows = tmux_list({ 'list-windows', '-F', '#{window_name}\t#{window_id}' })
  local window_id = nil

  for _, line in ipairs(windows) do
    local name, id = line:match('^(.-)\t(.+)$')
    if name == window_name then
      window_id = id
      break
    end
  end

  if window_id then
    return M.select_window(window_id)
  end

  if command and command ~= '' then
    return tmux({ 'new-window', '-n', window_name, command })
  end

  return tmux({ 'new-window', '-n', window_name })
end

function M.send_to_window(window_name, command, opts)
  if not in_tmux() then
    vim.notify('Not inside tmux', vim.log.levels.WARN)
    return
  end

  opts = opts or {}
  local cwd = opts.cwd or vim.fn.getcwd()
  local target_exists = false
  local windows = tmux_list({ 'list-windows', '-F', '#{window_name}' })

  for _, name in ipairs(windows) do
    if trim(name) == window_name then
      target_exists = true
      break
    end
  end

  if not target_exists then
    tmux({ 'new-window', '-n', window_name })
  end

  local keys = string.format('cd %s && %s', vim.fn.shellescape(cwd), command)
  local send_args = { 'send-keys', '-t', window_name }
  if target_exists and opts.interrupt ~= false then
    vim.list_extend(send_args, { 'C-c', 'C-l' })
  end
  vim.list_extend(send_args, { keys, 'C-m' })

  tmux(send_args)
  M.select_window(window_name)
end

return M
