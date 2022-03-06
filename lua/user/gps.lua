local status_ok, gps = pcall(require, "nvim-gps")
if not status_ok then
	return
end
local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
	return
end
gps.setup()


lualine.setup({
	sections = {
			lualine_c = {
				{ gps.get_location, cond = gps.is_available },
			}
	}
})
