local M = {}

local state = {
  active = false,
  files = {},
  idx = 1,
  root = nil,
  tabnr = nil,
  bufnr = nil,
}

local function trim(s)
  return (s or ""):gsub("^%s+", ""):gsub("%s+$", "")
end

local function git_cmd(root, args)
  local cmd = string.format("git -C %s %s", vim.fn.shellescape(root), args)
  local out = vim.fn.systemlist(cmd)
  if vim.v.shell_error ~= 0 then
    return nil, table.concat(out, "\n")
  end
  return out, nil
end

local function repo_root()
  local out = vim.fn.systemlist("git rev-parse --show-toplevel")
  if vim.v.shell_error ~= 0 or not out[1] then
    return nil
  end
  return trim(out[1])
end

local function close_review_tab()
  if state.tabnr and vim.api.nvim_tabpage_is_valid(state.tabnr) then
    pcall(vim.api.nvim_set_current_tabpage, state.tabnr)
    pcall(vim.cmd, "tabclose")
  end
end

local function finish_review(close_view)
  if close_view then
    close_review_tab()
  end
  state.active = false
  state.files = {}
  state.idx = 1
  state.root = nil
  state.tabnr = nil
  state.bufnr = nil
end

local function current_file()
  return state.files[state.idx]
end

local function next_file()
  state.idx = state.idx + 1
  if not current_file() then
    finish_review(true)
    return
  end

  vim.schedule(function()
    M.open_current()
  end)
end

local function set_buffer_content(buf, lines)
  vim.bo[buf].modifiable = true
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)
  vim.bo[buf].modifiable = false
end

local function apply_review_keymaps(buf)
  vim.keymap.set("n", " ", function()
    if not state.active then
      return
    end

    local file = current_file()
    if not file then
      finish_review(true)
      return
    end

    local _, err = git_cmd(state.root, "add -- " .. vim.fn.shellescape(file))
    if err then
      vim.notify("CodeReview stage failed: " .. err, vim.log.levels.ERROR)
      return
    end

    next_file()
  end, { buffer = buf, silent = true, nowait = true, desc = "CodeReview stage file and next" })

  vim.keymap.set("n", "s", function()
    if not state.active then
      return
    end
    next_file()
  end, { buffer = buf, silent = true, nowait = true, desc = "CodeReview skip file and next" })

  vim.keymap.set("n", "q", function()
    if state.active then
      finish_review(true)
    end
  end, { buffer = buf, silent = true, nowait = true, desc = "CodeReview quit" })
end

local function ensure_review_tab_and_buf()
  if state.tabnr and vim.api.nvim_tabpage_is_valid(state.tabnr) and state.bufnr and vim.api.nvim_buf_is_valid(state.bufnr) then
    pcall(vim.api.nvim_set_current_tabpage, state.tabnr)
    local win = vim.api.nvim_tabpage_get_win(state.tabnr)
    pcall(vim.api.nvim_win_set_buf, win, state.bufnr)
    return
  end

  vim.cmd("tabnew")
  state.tabnr = vim.api.nvim_get_current_tabpage()
  state.bufnr = vim.api.nvim_get_current_buf()

  local buf = state.bufnr
  vim.bo[buf].buftype = "nofile"
  vim.bo[buf].bufhidden = "wipe"
  vim.bo[buf].swapfile = false
  vim.bo[buf].modifiable = false
  vim.bo[buf].filetype = "diff"
  apply_review_keymaps(buf)
end

function M.open_current()
  local file = current_file()
  if not file then
    finish_review(true)
    return
  end

  ensure_review_tab_and_buf()

  local lines, err = git_cmd(state.root, "diff --no-color -- " .. vim.fn.shellescape(file))
  if err then
    vim.notify("CodeReview diff failed: " .. err, vim.log.levels.ERROR)
    finish_review(true)
    return
  end

  if #lines == 0 then
    next_file()
    return
  end

  local header = {
    string.format("# CodeReview %d/%d", state.idx, #state.files),
    string.format("# File: %s", file),
    "# Keys: <Space> stage+next | s skip | q quit",
    "",
  }

  local all_lines = vim.list_extend(header, lines)
  set_buffer_content(state.bufnr, all_lines)
  vim.api.nvim_buf_set_name(state.bufnr, "CodeReview://" .. file)
  vim.bo[state.bufnr].modifiable = false
  vim.bo[state.bufnr].readonly = true
  vim.api.nvim_win_set_cursor(0, { 1, 0 })
end

function M.start()
  local root = repo_root()
  if not root then
    vim.notify("CodeReview: not in a git repository", vim.log.levels.ERROR)
    return
  end

  local files, err = git_cmd(root, "diff --name-only --diff-filter=ACMR")
  if err then
    vim.notify("CodeReview: " .. err, vim.log.levels.ERROR)
    return
  end

  if #files == 0 then
    vim.notify("CodeReview: no unstaged changes", vim.log.levels.INFO)
    return
  end

  if state.active then
    finish_review(true)
  end

  state.active = true
  state.files = files
  state.idx = 1
  state.root = root
  state.tabnr = nil
  state.bufnr = nil

  M.open_current()
end

vim.api.nvim_create_user_command("CodeReview", function()
  M.start()
end, {
  desc = "Review unstaged files one-by-one: <Space>=stage+next, s=skip, q=quit",
})

return M
