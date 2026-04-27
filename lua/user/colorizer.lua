local status_ok, colorizer = pcall(require, "colorizer")
if not status_ok then
  print("colorizer not found")
  return
end

colorizer.setup({
  filetypes = { "*" },
  options = {
    parsers = {
      hex = {
        default = false,
        rgb = true,
        rrggbb = true,
        rrggbbaa = true,
      },
      names = { enable = false },
      rgb = { enable = true },
      hsl = { enable = true },
    },
    display = {
      mode = "background",
    },
  },
})
