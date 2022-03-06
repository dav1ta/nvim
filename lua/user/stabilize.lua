
local status_ok, lualine = pcall(require, "stabilize")
if not status_ok then
	return
end
require("stabilize").setup()local status_ok, lualine = pcall(require, "nvim-gps")
