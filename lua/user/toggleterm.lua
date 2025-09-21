-- ToggleTerm quick cues:
-- 1. `<C-\>` → open or hide the last terminal in a split instantly.
-- 2. `jk` inside terminal → drop back to normal mode without leaving insert.
-- 3. `<C-h/j/k/l>` in terminal → hop between editor windows seamlessly.
-- 4. `:ToggleTerm direction=float` → pop a one-off floating shell when needed.
-- 5. `:lua _LAZYGIT_TOGGLE()` → launch LazyGit for fast repo triage.
-- 6. `:lua _RUN_TOGGLE()` → spin up the custom `run` command shell.
-- 7. Adjust `direction`/`size` below to suit project-specific terminal layouts.

function setup()
local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then
    print("toggleterm not found")
	return
end

toggleterm.setup({
	size = 20,
	open_mapping = [[<c-\>]],
	hide_numbers = true,
	shade_filetypes = {},
	shade_terminals = true,
	shading_factor = 2,
	start_in_insert = true,
	insert_mappings = true,
	persist_size = true,
	direction = "horizontal",
	close_on_exit = true,
	shell = vim.o.shell,
	float_opts = {
		border = "curved",
		winblend = 0,
		highlights = {
			border = "Normal",
			background = "Normal",
		},
	},
})

function _G.set_terminal_keymaps()
  local opts = {noremap = true}
  -- vim.api.nvim_buf_set_keymap(0, 't', '<esc>', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', 'jk', [[<C-\><C-n>]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-h>', [[<C-\><C-n><C-W>h]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-j>', [[<C-\><C-n><C-W>j]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-k>', [[<C-\><C-n><C-W>k]], opts)
  vim.api.nvim_buf_set_keymap(0, 't', '<C-l>', [[<C-\><C-n><C-W>l]], opts)
end

vim.cmd('autocmd! TermOpen term://* lua set_terminal_keymaps()')

local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", direction = "horizontal",hidden = true })

function _LAZYGIT_TOGGLE()
	lazygit:toggle()
end




local run = Terminal:new({ cmd = "run",
                          hidden = true,
                          direction = 'horizontal',
                           close_on_exit = false,
})


function _RUN_TOGGLE()
	run:toggle()
end
end
return {setup=setup}
