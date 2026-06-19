-- NvimTree quick cues:
-- 1. `<leader>e` -> toggle the file explorer when changing files.
-- 2. `a` inside the tree -> create a new file or folder in place.
-- 3. `r` -> rename the selected node to keep things organized.
-- 4. `d` -> delete files after double-checking they are tracked.
-- 5. `R` -> refresh the tree when git status feels out of sync.
-- 6. `<CR>` -> open the highlighted file in the current window.
-- 7. `<C-v>` / `<C-x>` -> split open files without losing context.

local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  print("nvim-tree not found")
  return
end

nvim_tree.setup({
  disable_netrw = true,
  hijack_netrw = true,
  hijack_unnamed_buffer_when_opening = true,
  sort = {
    sorter = "name",
  },
  view = {
    width = 40,
    side = "left",
    signcolumn = "yes",
  },
  renderer = {
    root_folder_label = ":~:s?$?/..?",
    icons = {
      symlink_arrow = " ➛ ",
      glyphs = {
        default = "",
        symlink = "",
        bookmark = "",
        modified = "●",
        folder = {
          arrow_closed = "",
          arrow_open = "",
          default = "",
          open = "",
          empty = "",
          empty_open = "",
          symlink = "",
          symlink_open = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
  actions = {
    change_dir = {
      enable = true,
      global = false,
    },
    open_file = {
      quit_on_open = false,
      resize_window = true,
      window_picker = {
        enable = true,
        exclude = {
          filetype = { "notify", "packer", "qf", "diff", "fugitive", "fugitiveblame" },
          buftype = { "nofile", "terminal", "help" },
        },
      },
    },
  },
  trash = {
    cmd = "gio trash",
  },
})
