function setup()

local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then
    print("nvim-treesitter not found")
  return
end

configs.setup {
  ensure_installed = { "c", "lua","python","bash","dockerfile","gitignore","go","tsx","html","scss","css","javascript",'yaml'},
  sync_install = false, -- install languages synchronously (only applied to `ensure_installed`)
  ignore_install = { "" }, -- List of parsers to ignore installing
  matchup = {
    enable = false, -- mandatory, false will disable the whole extension
    disable_virtual_text = false,
    disable = { "html" }, -- optional, list of language that will be disabled
    -- include_match_words = false
  },
  highlight = {
    -- use_languagetree = true,
    enable = true, -- false will disable the whole extension
    -- disable = { "css", "html" }, -- list of language that will be disabled
    -- disable = { "css", "markdown" }, -- list of language that will be disabled
    disable = { "markdown" }, -- list of language that will be disabled
    -- additional_vim_regex_highlighting = true,
    -- disable = function(lang, buf)
    --     local max_filesize = 100 * 1024 -- 100 KB
    --     local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
    --     if ok and stats and stats.size > max_filesize then
    --         return true
    --     end
    -- end,

    -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
    -- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
    -- Using this option may slow down your editor, and you may see some duplicate highlights.
    -- Instead of true it can also be a list of languages
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true, disable = { "python", "css", "rust" } },
  context_commentstring = {
    enable = true,
    enable_autocmd = false,
  },
  autotag = {
    enable = true,
    disable = { "xml", "markdown" },
  },
  rainbow = {
    enable = true,
    extended_mode = false,
    colors = {
      "Gold",
      "Orchid",
      "DodgerBlue",
    },
    disable = { "html" },
    max_file_lines = 1000,
  },
  playground = {
    enable = false,
  },
  textobjects = {
    select = {
      enable = true,
      -- Automatically jump forward to textobj, similar to targets.vim
      lookahead = true,
      keymaps = {
        -- You can use the capture groups defined in textobjects.scm
        ["af"] = "@function.outer",
        ["if"] = "@function.inner",
        ["at"] = "@class.outer",
        ["it"] = "@class.inner",
        ["ac"] = "@call.outer",
        ["ic"] = "@call.inner",
        ["aa"] = "@parameter.outer",
        ["ia"] = "@parameter.inner",
        ["al"] = "@loop.outer",
        ["il"] = "@loop.inner",
        ["ai"] = "@conditional.outer",
        ["ii"] = "@conditional.inner",
        ["a/"] = "@comment.outer",
        ["i/"] = "@comment.inner",
        ["ab"] = "@block.outer",
        ["ib"] = "@block.inner",
        ["as"] = "@statement.outer",
        ["is"] = "@scopename.inner",
        ["aA"] = "@attribute.outer",
        ["iA"] = "@attribute.inner",
        ["aF"] = "@frame.outer",
        ["iF"] = "@frame.inner",
      },
    },
    move = {
      enable = true,
      set_jumps = true, -- whether to set jumps in the jumplist
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
