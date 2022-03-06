local status_ok, lualine = pcall(require, "nvim-gps")
if not status_ok then
	return
end
require("nvim-lastplace").setup({})

