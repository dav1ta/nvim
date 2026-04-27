-- Utility functions shared across config
local M = {}

-- Large file detection threshold (in bytes)
M.LARGE_FILE_THRESHOLD = 500 * 1024 -- 500 KB

M.ROOT_PATTERNS = {
  ".git",
  "_darcs",
  ".hg",
  ".bzr",
  ".svn",
  "Makefile",
  "package.json",
  "docker-compose.yml",
  ".env",
  "Cargo.lock",
  "Cargo.toml",
  "go.mod",
  "go.sum",
  "requirements.txt",
  "pyproject.toml",
  "Pipfile",
  "Pipfile.lock",
  ".python-version",
  "yarn.lock",
  "package-lock.json",
  "Dockerfile",
}

function M.find_project_root(path)
  path = path ~= "" and path or vim.uv.cwd()
  local root = vim.fs.root(path, M.ROOT_PATTERNS)
  return root or vim.uv.cwd()
end

-- Check if a file/buffer is large and should have features disabled
function M.is_large_file(bufnr)
  bufnr = bufnr or 0
  
  -- Check if already marked
  if vim.b[bufnr].large_buf ~= nil then
    return vim.b[bufnr].large_buf
  end
  
  local filepath = vim.api.nvim_buf_get_name(bufnr)
  if filepath == "" then
    return false
  end
  
  local ok, stats = pcall(vim.uv.fs_stat, filepath)
  if ok and stats and stats.size > M.LARGE_FILE_THRESHOLD then
    vim.b[bufnr].large_buf = true
    return true
  end
  
  vim.b[bufnr].large_buf = false
  return false
end

-- Disable heavy features for large files
function M.disable_heavy_features(bufnr)
  bufnr = bufnr or 0
  
  vim.notify(
    string.format("Large file detected (%s): disabled heavy features for performance", 
    vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":t")),
    vim.log.levels.WARN
  )
  
  -- Disable syntax
  vim.cmd("syntax off")
  vim.bo[bufnr].syntax = "off"
  
  -- Disable folding
  vim.wo.foldmethod = "manual"
  
  -- Disable Treesitter highlighting
  pcall(vim.cmd, "TSBufDisable highlight")
  
  -- Pause illuminate
  pcall(vim.cmd, "IlluminatePauseBuf")
end

return M




