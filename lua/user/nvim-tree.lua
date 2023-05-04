local status_ok, nvim_tree = pcall(require, "nvim-tree")
if not status_ok then
  print("nvim-tree not found")
  return
end
--  local function telescope_find_files(_)
--   start_telescope('find_files')
--   end


-- function start_telescope(telescope_mode)
--   local node = require("nvim-tree.lib").get_node_at_cursor()
--   local abspath = node.link_to or node.absolute_path
--   local is_folder = node.open ~= nil
--   local basedir = is_folder and abspath or vim.fn.fnamemodify(abspath, ":h")
--   require("telescope.builtin")[telescope_mode] {
--     cwd = basedir,
--   }
-- end

-- local config_status_ok, nvim_tree_config = pcall(require, "nvim-tree.config")
-- if not config_status_ok then
--   return
-- end

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local icons = require("user.icons")

-- local tree_cb = nvim_tree_config.nvim_tree_callback

nvim_tree.setup {
    filters = {
    dotfiles = false,
    exclude = { vim.fn.stdpath "config" .. "/lua/custom" },
  },
  disable_netrw = true,
  hijack_netrw = true,
  hijack_cursor = true,
  hijack_unnamed_buffer_when_opening = false,
  sync_root_with_cwd = true,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  view = {
    adaptive_size = false,
    side = "left",
    width = 30,
    preserve_window_proportions = true,
  },
  git = {
    enable = false,
    ignore = true,
  },
  filesystem_watchers = {
    enable = true,
  },
  actions = {
    open_file = {
      resize_window = true,
    },
  },
  renderer = {
    root_folder_label = false,
    highlight_git = false,
    highlight_opened_files = "none",

    indent_markers = {
      enable = false,
    },

    icons = {
      show = {
        file = true,
        folder = true,
        folder_arrow = true,
        git = false,
      },

      glyphs = {
        default = "",
        symlink = "",
        folder = {
          default = "",
          empty = "",
          empty_open = "",
          open = "",
          symlink = "",
          symlink_open = "",
          arrow_open = "",
          arrow_closed = "",
        },
        git = {
          unstaged = "✗",
          staged = "✓",
          unmerged = "",
          renamed = "➜",
          untracked = "★",
          deleted = "",
          ignored = "◌",
        },
      },
    },
  },
}
