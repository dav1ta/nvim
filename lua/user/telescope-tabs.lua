-- Telescope Tabs quick cues:
-- 1. `<leader>aa` → open the tabs picker for fast workspace hopping.
-- 2. `dd` inside the picker → close a tab while staying in list view.
-- 3. `<C-d>` in insert mode → same close action without leaving insert.
-- 4. Start typing → fuzzy-match tab labels by active buffer names.
-- 5. `Tab` / `<C-n>` → cycle through candidates when indecisive.
-- 6. Adjust `entry_formatter` below to surface project metadata.
-- 7. Flip `show_preview` if you ever want per-tab previews.

local M = {
  "LukasPietzschmann/telescope-tabs",
  event = "VeryLazy",
}

function M.config()
  -- No keymaps registered; user requested removal of Telescope Tabs mapping

  require("telescope-tabs").setup {
    show_preview = false,
    close_tab_shortcut_i = "<C-d>", -- if you're in insert mode
    close_tab_shortcut_n = "dd", -- if you're in normal mode
    entry_formatter = function(tab_id, buffer_ids, file_names, file_paths, is_current)
      local entry_string = table.concat(file_names, ", ")
      return string.format("%d: %s%s", tab_id, entry_string, is_current and " " or "")
    end,
  }
end

return M
