function setup()
local status_ok, trouble = pcall(require, "trouble")
if not status_ok then
    print("trouble not found")
	return
end

trouble.setup({
  auto_open = false,
  auto_close = false,
  focus = true,
  warn_no_results = false,
  open_no_results = false,
  use_diagnostic_signs = true,
  keys = {
    ["q"] = "close",
    ["<esc>"] = "cancel",
    ["r"] = "refresh",
    ["<cr>"] = "jump",
    ["<c-x>"] = "open_split",
    ["<c-v>"] = "open_vsplit",
    ["<c-t>"] = "open_tab",
    ["o"] = "jump_close",
    ["K"] = "hover",
    ["p"] = "preview",
    ["zM"] = "fold_close_all",
    ["zR"] = "fold_open_all",
    ["za"] = "fold_toggle",
    ["k"] = "prev",
    ["j"] = "next",
  },
  modes = {
    diagnostics = {
      groups = { { "filename", format = "path:relative" }, "pos", "message" },
      win = { position = "bottom", size = 10 },
      preview = { type = "main", scratch = true },
      format = "{severity_icon} {message} ({source})",
    },
    symbols = {
      win = { position = "left" },
    },
    lsp = {
      win = { position = "bottom" },
    },
    qflist = {},
    loclist = {},
  },
})

vim.api.nvim_set_keymap("n", "btt", "<cmd>TroubleToggle<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "btw", "<cmd>Trouble workspace_diagnostics<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>td", "<cmd>Trouble document_diagnostics<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tl", "<cmd>Trouble loclist<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tq", "<cmd>Trouble quickfix<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "gR", "<cmd>Trouble lsp_references<cr>", { silent = true, noremap = true })
vim.api.nvim_set_keymap("n", "<leader>xx", "<cmd>lua require('user.functions').toggle_diagnostics()<CR>", { noremap = true, silent = true })

end
return {setup=setup}
