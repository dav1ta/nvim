-- Octo.nvim quick cues:
-- 1. Pick a PR context: `<leader>gp`/`:Octo pr list` then `<CR>`, or `:Octo pr checkout <num>` / `:Octo pr edit <num>` / `:Octo <PR-url>`.
-- 2. Inside the PR buffer, `<leader>gr` or `:Octo review start` opens the review tab with file panel + diffs.
-- 3. Navigate files with `]q`/`[q` or the file panel; `]c`/`[c` moves between threaded comments.
-- 4. Add feedback: visual-select lines in the diff → `<localleader>ca` (comment) or `<localleader>sa` (suggestion).
-- 5. Check pending notes via `:Octo review comments`; jump to one with `<CR>`.
-- 6. Finish with `:Octo review submit` then choose comment/approve/request_changes; resume later via `:Octo review resume`.
-- 7. Abort/pause workflows using `:Octo review close` (exit tab) or `:Octo review discard` (drop pending remarks).
-- 8. `:Octo issue edit <num>` keeps issue details up to date without leaving Neovim.
-- 9. `:Octo comment add` works in any Octo buffer for quick replies.
-- 10. Explore `:Octo actions` when you forget a subcommand.

local M = {
  "pwntester/octo.nvim",
  cmd = "Octo",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope.nvim",
    "nvim-tree/nvim-web-devicons",
  },
}

function M.config()
  local ok, octo = pcall(require, "octo")
  if not ok then
    return
  end

  octo.setup({
    use_local_fs = false,
    default_remote = { "upstream", "origin" },
    default_merge_method = "commit",
    picker = "telescope",
    picker_config = {
      mappings = {
        open_in_browser = { lhs = "<C-b>", desc = "Open in browser" },
        copy_url = { lhs = "<C-y>", desc = "Copy URL" },
        checkout_pr = { lhs = "<C-o>", desc = "Checkout PR" },
        merge_pr = { lhs = "<C-r>", desc = "Merge PR" },
      },
    },
    reviews = {
      auto_show_threads = true,
      focus = "right",
    },
    notifications = {
      current_repo_only = false,
    },
    mappings_disable_default = false,
  })

  local wk_ok, wk = pcall(require, "which-key")
  if wk_ok then
    wk.add({
      { "<leader>gi", "<cmd>Octo issue list<cr>", desc = "Issues (Octo)" },
      { "<leader>gp", "<cmd>Octo pr list<cr>", desc = "PRs (Octo)" },
      { "<leader>gr", "<cmd>Octo review start<cr>", desc = "Start Review (Octo)" },
    })
  end
end

return M
