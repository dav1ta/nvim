-- Set leader keys early
vim.g.mapleader = " "
vim.g.maplocalleader = " "

local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- Disable space in normal/visual mode (leader key)
keymap({"n", "v"}, "<Space>", "<Nop>", opts)

-- Goto-preview bindings
keymap("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", opts)
keymap("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", opts)

-- Modes
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Normal --
-- Better window navigation
keymap("n", "<C-h>", "<C-w>h", opts)
keymap("n", "<C-j>", "<C-w>j", opts)
keymap("n", "<C-k>", "<C-w>k", opts)
keymap("n", "<C-l>", "<C-w>l", opts)

-- Resize with arrows
keymap("n", "<C-Up>", ":resize -2<CR>", opts)
keymap("n", "<C-Down>", ":resize +2<CR>", opts)
keymap("n", "<C-Left>", ":vertical resize -2<CR>", opts)
keymap("n", "<C-Right>", ":vertical resize +2<CR>", opts)

-- Better delete/cut behavior
keymap("n", "d", '"0d', opts)  -- Delete to black hole, yank stays in "0
keymap("n", "x", '"_x', opts)  -- x deletes to black hole

-- Visual --
-- Stay in indent mode
keymap("v", "<", "<gv", opts)
keymap("v", ">", ">gv", opts)

-- Move text up and down
keymap("v", "<S-j>", ":m .+1<CR>==", opts)
keymap("v", "<S-k>", ":m .-2<CR>==", opts)
keymap("v", "p", '"_dP', opts)

-- Visual Block --
-- Move text up and down
keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
keymap("x", "K", ":move '<-2<CR>gv-gv", opts)

-- DAP (Debug Adapter Protocol) - F-keys for debugging
keymap('n', '<F5>', '<cmd>lua require("dap").continue()<cr>', opts)
keymap('n', '<F9>', '<cmd>lua require("dap").toggle_breakpoint()<cr>', opts)
keymap('n', '<F10>', '<cmd>lua require("dap").step_over()<cr>', opts)
keymap('n', '<F11>', '<cmd>lua require("dap").step_into()<cr>', opts)
keymap('n', '<F12>', '<cmd>lua require("dap").step_out()<cr>', opts)



-- Runner command
keymap('n', '<leader>5', '<cmd>Ru<cr>', opts)

-- Tab navigation
keymap("n", ",1", '1gt', opts)
keymap("n", ",2", '2gt', opts)
keymap("n", ",3", '3gt', opts)
keymap("n", ",4", '4gt', opts)

-- Smooth scrolling (8 lines at a time)
keymap('n', '<C-d>', '8<C-e>', opts)
keymap('n', '<C-u>', '8<C-y>', opts)

-- Diagnostic navigation
keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
keymap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
keymap('n', '<leader>q', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)

-- Formatting
keymap("n", "<leader>lf", ":Format<CR>", opts)
