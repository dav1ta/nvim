local function setup()
  local status_ok, configs = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    vim.notify("nvim-treesitter not found", vim.log.levels.ERROR)
    return
  end

  configs.setup {
    ensure_installed = {
      "c", "lua", "python", "bash", "diff", "dockerfile", "gitignore", "go", "tsx", "typescript",
      "html", "scss", "css", "javascript", "yaml"
    },
    sync_install = false,
    ignore_install = {},

    highlight = {
      enable = true,
      disable = function(lang, buf)
        local utils = require("user.utils")
        return utils.is_large_file(buf)
      end,
      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true,
      disable = {},
    },

    -- matchup removed (plugin not installed)

    -- playground removed: plugin not installed and you don't use it

    textobjects = {
      select = {
        enable = true,
        lookahead = true,
        keymaps = {
          ["af"] = "@function.outer",
          ["if"] = "@function.inner",
          ["ac"] = "@class.outer",
          ["ic"] = "@class.inner",
          ["ap"] = "@parameter.outer",
          ["ip"] = "@parameter.inner",
        },
      },

      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]m"] = "@function.outer",
          ["]]"] = "@class.outer",
        },
        goto_next_end = {
          ["]M"] = "@function.outer",
          ["]["] = "@class.outer",
        },
        goto_previous_start = {
          ["[m"] = "@function.outer",
          ["[["] = "@class.outer",
        },
        goto_previous_end = {
          ["[M"] = "@function.outer",
          ["[]"] = "@class.outer",
        },
      },

      swap = {
        enable = true,
        swap_next = {
          ["<leader>."] = "@parameter.inner",
        },
        swap_previous = {
          ["<leader>,"] = "@parameter.inner",
        },
      },
    },
  }
end

return {
  setup = setup
}
