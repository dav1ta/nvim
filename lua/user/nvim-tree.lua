vim.g.nvim_tree_respect_buf_cwd = 1

require("nvim-tree").setup({
  disable_netrw = true,
  hijack_netrw = true,
  update_cwd = true,
  open_on_setup_file = false,
  sort_by = "name",
  ignore_buffer_on_setup = false,
  ignore_ft_on_setup = {
        "startify",
        "dashboard",
        "alpha",
      },
   auto_reload_on_write = true,
   hijack_unnamed_buffer_when_opening = false,
      hijack_directories = {
        enable = true,
        auto_open = true,
      },
        open_on_tab = false,
              hijack_cursor = false,
  update_focused_file = {
    enable = true,
    update_cwd = true,
  },
  diagnostics = {
    enable = true,
    icons = {
      hint = "",
      info = "",
      warning = "",
      error = "",
    },
  },
  filters = {
    dotfiles = true,
    custom = {},
  },
  git = {
    enable = true,
    ignore = true,
    timeout = 400,
  },
   view = {
        width = 30,
        height = 30,
        hide_root_folder = false,
        side = "left",
        preserve_window_proportions = false,
        mappings = {
          custom_only = false,
          list = {},
        },
        number = false,
        relativenumber = false,
        signcolumn = "yes",
      },
})
