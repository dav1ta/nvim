local actions = require("diffview.actions")

  require('diffview').setup({
    diff_binaries = false,
    enhanced_diff_hl = false, -- Set up hihglights in the hooks instead
    git_cmd = { "git" },
    hg_cmd = { "chg" },
    use_icons = true,
    show_help_hints = false,
    icons = {
      folder_closed = "",
      folder_open = "",
    },
    signs = {
      fold_closed = "",
      fold_open = "",
    },
    view = {
      default = {
        -- layout = "diff1_inline",
        winbar_info = false,
      },
      -- merge_tool = {
      --   layout = "diff3_mixed",
      --   disable_diagnostics = true,
      --   winbar_info = true,
      -- },
      file_history = {
        -- layout = "diff1_inline",
        winbar_info = false,
      },
    },
    file_panel = {
      listing_style = "tree",
      tree_options = {
        flatten_dirs = true,
        folder_statuses = "only_folded",
      },
      win_config = {
        position = "left",
        width = 35,
      },
    },
    file_history_panel = {
      log_options = {
        git = {
          single_file = {
            diff_merges = "combined",
            follow = true,
          },
          multi_file = {
            diff_merges = "first-parent",
          },
        },
      },
      win_config = {
        position = "bottom",
        height = 16,
      },
    },
    default_args = {
      DiffviewOpen = {},
      DiffviewFileHistory = {},
    },
    hooks = {
      diff_buf_read = function()
        vim.opt_local.wrap = false
      end,
      ---@diagnostic disable-next-line: unused-local
      diff_buf_win_enter = function(bufnr, winid, ctx)
        -- Highlight 'DiffChange' as 'DiffDelete' on the left, and 'DiffAdd' on
        -- the right.
        if ctx.layout_name:match("^diff2") then
          if ctx.symbol == "a" then
            vim.opt_local.winhl = table.concat({
              "DiffAdd:DiffviewDiffAddAsDelete",
              "DiffDelete:DiffviewDiffDelete",
              "DiffChange:DiffAddAsDelete",
              "DiffText:DiffDeleteText",
            }, ",")
          elseif ctx.symbol == "b" then
            vim.opt_local.winhl = table.concat({
              "DiffDelete:DiffviewDiffDelete",
              "DiffChange:DiffAdd",
              "DiffText:DiffAddText",
            }, ",")
          end
        end
      end,
    },
    keymaps = {
      view = {
        { "n", "-", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
      },
      file_panel = {
        { "n", "<cr>", actions.focus_entry, { desc = "Focus the selected entry" } },
        { "n", "s", actions.toggle_stage_entry, { desc = "Stage / unstage the selected entry" } },
        { "n", "cc",  "<Cmd>Git commit <bar> wincmd J<CR>", { desc = "Commit staged changes" } },
        { "n", "ca",   "<Cmd>Git commit --amend <bar> wincmd J<CR>", { desc = "Amend the last commit" } },
        { "n", "c<space>",  ":Git commit ", { desc = "Populate command line with \":Git commit \"" } },
      },
      file_history_panel = {
        { "n", "<cr>", actions.focus_entry, { desc = "Focus the selected entry" } },
      },
    }
  })
