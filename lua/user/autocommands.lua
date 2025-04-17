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



vim.api.nvim_create_user_command(
  'SudoWrite',
  function()
    local password = vim.fn.inputsecret("Enter sudo password: ")
    vim.fn.system('echo ' .. password .. ' | sudo -S tee % >/dev/null', vim.fn.expand('%:p'))
    vim.cmd('e!')
  end,
  {}
)




-- Disable heavy features for large files
vim.api.nvim_create_autocmd("BufReadPre", {
  callback = function(args)
    local file = args.file
    local size = vim.fn.getfsize(file)
    if size > 1000000 then -- ~1MB
      vim.b.large_buf = true
      vim.cmd("syntax off")
      vim.opt_local.foldmethod = "manual"

      -- Disable Treesitter highlighting if available
      pcall(vim.cmd, "TSBufDisable highlight")

      -- Pause illuminate if available
      pcall(vim.cmd, "IlluminatePauseBuf")

      -- Optional: notify
      vim.notify("Large file detected: disabled highlighting and folding for performance.", vim.log.levels.WARN)
    end
  end
})
