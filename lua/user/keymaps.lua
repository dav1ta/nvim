local opts = { noremap = true, silent = true }

local term_opts = { silent = true }

-- Shorten function name
local keymap = vim.api.nvim_set_keymap

--Remap space as leader key
keymap("", "<Space>", "<Nop>", opts)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

vim.api.nvim_set_keymap("n", "gp", "<cmd>lua require('goto-preview').goto_preview_definition()<CR>", {noremap=true})
vim.api.nvim_set_keymap("n", "gP", "<cmd>lua require('goto-preview').close_all_win()<CR>", {noremap=true})

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


keymap("n", "d", '"0d', opts)
keymap("n", "x", '"_x', opts)

-- Navigate buffers

-- Move text up and down
-- keymap("n", "<A-j>", "<Esc>:m .+1<CR>==gi", opts)
-- keymap("n", "<A-k>", "<Esc>:m .-2<CR>==gi", opts)

-- Insert --
-- Press jk fast to enter

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


-- Terminal --
-- Better terminal navigation
-- keymap("t", "<C-h>", "<C-\\><C-N><C-w>h", term_opts)
-- keymap("t", "<C-j>", "<C-\\><C-N><C-w>j", term_opts)
-- keymap("t", "<C-k>", "<C-\\><C-N><C-w>k", term_opts)
-- keymap("t", "<C-l>", "<C-\\><C-N><C-w>l", term_opts)

keymap('n', '<Up>', '<cmd> lua require("dap").step_out()<cr>', opts)
keymap('n', '<Down>', '<cmd> lua require("dap").step_over()<cr>', opts)
keymap('n', '<Left>', '<cmd> lua require("dap").toggle_breakpoint()<cr>', opts)
keymap('n', '<Right>', '<cmd> lua require("dap").step_into()<cr>', opts)



keymap('n', '<leader>1', '<cmd> BufferLineGoToBuffer 1 <cr>', opts)
keymap('n', '<leader>2', '<cmd> BufferLineGoToBuffer 2 <cr>', opts)
keymap('n', '<leader>3', '<cmd> BufferLineGoToBuffer 3 <cr>', opts)
keymap('n', '<leader>4', '<cmd> BufferLineGoToBuffer 4 <cr>', opts)
keymap('n','<leader>p','"0p',opts)


keymap("n", ",1", '1gt', opts)
keymap("n", ",2", '2gt', opts)
keymap("n", ",3", '3gt', opts)
keymap("n", ",4", '4gt', opts)


