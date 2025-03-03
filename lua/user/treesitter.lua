local function setup()
  local status_ok, configs = pcall(require, "nvim-treesitter.configs")
  if not status_ok then
    vim.notify("nvim-treesitter not found", vim.log.levels.ERROR)
    return
  end

  configs.setup {
    ensure_installed = {
      "c", "lua", "python", "bash", "dockerfile", "gitignore", "go", "tsx",
      "html", "scss", "css", "javascript", "yaml"
    },
    sync_install = false,
    ignore_install = {},

    highlight = {
      enable = true,
      disable = function(lang, buf)
        local max_filesize = 500 * 1024 -- 500 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
        return false
      end,
      additional_vim_regex_highlighting = false,
    },

    indent = {
      enable = true,
      disable = { "css", "rust" },
    },

    context_commentstring = {
      enable = true,
      enable_autocmd = false,
    },

    matchup = {
      enable = true,
      disable = { "html","markdown" },
    },

    playground = {
      enable = true,
      disable = {},
      updatetime = 25,
      persist_queries = false,
    },

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

