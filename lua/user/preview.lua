-- GotoPreview quick cues:
-- 1. `gp` → peek the definition in a floating window (set in keymaps.lua).
-- 2. `gP` → close all preview windows once you are done scanning.
-- 3. `:GotoPreviewDefinition` → manually open a definition preview elsewhere.
-- 4. `:GotoPreviewImplementation` → inspect implementations without leaving the file.
-- 5. `:GotoPreviewReferences` → list references in previews for faster code spelunking.
-- 6. `:GotoPreviewCloseAll` → clear every preview panel when the stack grows.
-- 7. Adjust `border` below to match your UI theme preferences.

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
