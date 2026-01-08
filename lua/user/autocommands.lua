vim.api.nvim_create_autocmd({ "User" }, {
  pattern = { "AlphaReady" },
  callback = function()
    vim.cmd [[
      set showtabline=0 | autocmd BufUnload <buffer> set showtabline=2
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "qf", "help", "man", "lspinfo", "spectre_panel" },
  callback = function()
    vim.cmd [[
      nnoremap <silent> <buffer> q :close<CR>
      set nobuflisted
    ]]
  end,
})

vim.api.nvim_create_autocmd({ "FileType" }, {
  pattern = { "gitcommit", "markdown" },
  callback = function()
    vim.cmd [[
      setlocal wrap
      setlocal spell
    ]]
  end,
})


vim.api.nvim_create_autocmd({ "VimResized" }, {
  callback = function()
    vim.cmd "tabdo wincmd ="
  end,
})

vim.api.nvim_create_autocmd({ "CmdWinEnter" }, {
  callback = function()
    vim.cmd "quit"
  end,
})

vim.api.nvim_create_autocmd({ "BufWinEnter" }, {
  callback = function()
    vim.cmd "set formatoptions-=cro"
  end,
})

vim.api.nvim_create_autocmd({ "TextYankPost" }, {
  callback = function()
    vim.highlight.on_yank { higroup = "Visual", timeout = 150 }
  end,
})


vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    vim.cmd "hi link illuminatedWord LspReferenceText"
  end,
})



-- Secure sudo write: uses vim's built-in :write with sudo tee
-- Usage: :SudoWrite
vim.api.nvim_create_user_command(
  'SudoWrite',
  function()
    vim.cmd('write !sudo tee % > /dev/null')
    vim.cmd('edit!')
  end,
  { desc = "Write file with sudo" }
)




-- Disable heavy features for large files
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function(args)
    local utils = require("user.utils")
    if utils.is_large_file(args.buf) then
      utils.disable_heavy_features(args.buf)
    end
  end
})




