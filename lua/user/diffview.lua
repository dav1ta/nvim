-- Diffview quick cues:
-- 1. `<leader>gd` → open a diff to compare branches before commit.
-- 2. `<leader>gD` → close the diff when you are done reviewing.
-- 3. `:DiffviewFileHistory` → inspect file history after regressions.
-- 4. `:DiffviewOpen HEAD~1` → preview last commit changes fast.
-- 5. `]c` / `[c` inside Diffview → jump between changed hunks.
-- 6. `:DiffviewFocusFiles` → refocus on the file list if you get lost.
-- 7. `:DiffviewToggleFiles` → hide the file sidebar for more space.

local M = {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewToggleFiles", "DiffviewFocusFiles", "DiffviewFileHistory" },
  event = "VeryLazy",
  opts = {
    enhanced_diff_hl = true,  -- Better diff highlighting
    view = {
      default = {
        layout = "diff2_vertical",
      },
      file_history = {
        layout = "diff2_vertical",
      },
    },
  },
  config = function(_, opts)
    require("diffview").setup(opts)

    local ok, wk = pcall(require, "which-key")
    if ok then
      wk.add({
        { "<leader>gd", ":DiffviewOpen<CR>", desc = "DiffView Open" },
        { "<leader>gD", ":DiffviewClose<CR>", desc = "DiffView Close" },
        { "<leader>gh", ":DiffviewFileHistory %<CR>", desc = "File History" },
      })
    end
  end,
}

return M

