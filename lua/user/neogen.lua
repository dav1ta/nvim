function setup()
local status_ok, neogen = pcall(require, "neogen")
if not status_ok then
    print("neogen not found")
	return
end
neogen.setup({
    enabled = true,
})

end

return {setup=setup}
