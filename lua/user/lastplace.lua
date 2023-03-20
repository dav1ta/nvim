local status_ok, lastplace = pcall(require, "nvim-lastplace")
if not status_ok then
  print("nvim-lastplace not found")
	return
end
lastplace.setup({})

