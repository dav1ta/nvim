-- MiniSurround quick cues:
-- 1. `saiw'` → wrap the word under cursor in quotes when toggling strings.
-- 2. `sda"` → strip surrounding quotes before refactoring arguments.
-- 3. `sr'"` → swap single quotes for double quotes without retyping text.
-- 4. `sf)` → jump forward to inspect the next surrounding pair.
-- 5. `sF)` → search left to confirm the previous surround boundary.
-- 6. `sh` → highlight the active surround before replacing it.
-- 7. `sn5` → widen the search window when editing multi-line blocks.

local M = {
  "echasnovski/mini.surround",
  version = "*",
  event = "BufReadPre",
}

function M.config()
  require("mini.surround").setup({

    mappings = {
      add = 'sa', -- Add surrounding
      delete = 'sd', -- Delete surrounding
      find = 'sf', -- Find surrounding
      find_left = 'sF', -- Find surrounding (left)
      highlight = 'sh', -- Highlight surrounding
      replace = 'sr', -- Replace surrounding
      update_n_lines = 'sn', -- Update `n_lines`
      suffix_last = 'l', -- Suffix for last search
      suffix_next = 'n', -- Suffix for next search
    },
    n_lines = 20, -- Number of lines to search surroundings
    respect_selection_type = false, -- No special handling for selection type
    search_method = "cover", -- Search method: 'cover'
    silent = false, -- Allow informational feedback
  })

end

return M
