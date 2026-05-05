local M = {}

local state = {
  active = false,
  files = {},
  idx = 1,
  root = nil,
  tabnr = nil,
  tempdirs = {},
}

local python_bin = "/home/davit/Desktop/env/bin/python"
local textual_diff_script = vim.fn.stdpath("config") .. "/scripts/codereview_textual_diff.py"

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

local function git_blob(root, file)
  local cmd = string.format("git -C %s show %s", vim.fn.shellescape(root), vim.fn.shellescape(":" .. file))
  local out = vim.fn.system(cmd)
  if vim.v.shell_error ~= 0 then
    return nil, trim(out)
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
  state.tabnr = nil
end

local function cleanup_tempdirs()
  for _, dir in ipairs(state.tempdirs) do
    pcall(vim.fn.delete, dir, "rf")
  end
  state.tempdirs = {}
end

local function finish_review(close_view, completed)
  if close_view then
    close_review_tab()
  end
  cleanup_tempdirs()
  if completed then
    vim.notify("CodeReview: completed", vim.log.levels.INFO)
  end
  state.active = false
  state.files = {}
  state.idx = 1
  state.root = nil
  state.tabnr = nil
  state.tempdirs = {}
end

local function current_file()
  return state.files[state.idx]
end

local function next_file()
  state.idx = state.idx + 1
  if not current_file() then
    finish_review(true, true)
    return
  end

  vim.schedule(function()
    M.open_current()
  end)
end

local function prepare_original_file(file)
  local contents, err = git_blob(state.root, file)
  if err then
    return nil, err
  end

  local dir = vim.fn.tempname()
  local name = vim.fn.fnamemodify(file, ":t")
  if name == "" then
    name = "original"
  end
  local path = dir .. "/" .. name

  vim.fn.mkdir(dir, "p")
  vim.fn.writefile(vim.split(contents, "\n", { plain = true }), path, "b")
  table.insert(state.tempdirs, dir)
  return path, nil
end

function M.open_current()
  local file = current_file()
  if not file then
    finish_review(true, true)
    return
  end

  local original, err = prepare_original_file(file)
  if err then
    vim.notify("CodeReview original failed: " .. err, vim.log.levels.ERROR)
    finish_review(true, false)
    return
  end

  local modified = state.root .. "/" .. file
  if vim.fn.filereadable(modified) == 0 then
    vim.notify("CodeReview modified file missing: " .. file, vim.log.levels.ERROR)
    finish_review(true, false)
    return
  end

  close_review_tab()
  vim.cmd("tabnew")
  state.tabnr = vim.api.nvim_get_current_tabpage()
  vim.cmd("tcd " .. vim.fn.fnameescape(state.root))

  local title = string.format("%d/%d %s", state.idx, #state.files, file)
  local cmd = { python_bin, textual_diff_script, original, modified, title }
  vim.fn.termopen(cmd, {
    on_exit = function(_, code)
      vim.schedule(function()
        close_review_tab()
        if code == 10 then
          M.stage_current()
        elseif code == 11 then
          M.skip_current()
        elseif code == 12 then
          finish_review(false, false)
        elseif state.active then
          vim.notify("CodeReview diff viewer exited: " .. code, vim.log.levels.ERROR)
          finish_review(false, false)
        end
      end)
    end,
  })
  vim.cmd("startinsert")
  vim.notify(string.format("CodeReview %d/%d: %s", state.idx, #state.files, file), vim.log.levels.INFO)
end

function M.stage_current()
  if not state.active then
    return
  end

  local file = current_file()
  if not file then
    finish_review(true, true)
    return
  end

  local _, err = git_cmd(state.root, "add -- " .. vim.fn.shellescape(file))
  if err then
    vim.notify("CodeReview stage failed: " .. err, vim.log.levels.ERROR)
    return
  end

  vim.notify("CodeReview: staged " .. file, vim.log.levels.INFO)
  next_file()
end

function M.skip_current()
  if not state.active then
    return
  end

  local file = current_file()
  if not file then
    finish_review(true, true)
    return
  end

  vim.notify("CodeReview: skipped " .. file, vim.log.levels.INFO)
  next_file()
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
  state.tempdirs = {}

  M.open_current()
end

vim.api.nvim_create_user_command("CodeReview", function()
  M.start()
end, {
  desc = "Review unstaged files one-by-one in Textual diff view: s=stage+next, n=skip+next, q=quit",
})

return M
