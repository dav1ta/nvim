
local status_ok, preview = pcall(require, "goto-preview")
if not status_ok then
  print("goto-preview not found")
	  return
  end

preview.setup({
    -- width = 120,
    -- height = 30,
    default_mappings = false,
    border = { "↖", "─", "╮", "│", "╯", "─", "╰", "│" },
})
