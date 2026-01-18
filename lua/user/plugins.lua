local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

vim.g.skip_ts_context_commentstring_module = true

if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- leader is set in keymaps.lua to avoid timing issues



-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end


-- Install your plugins here
return lazy.setup({
  -- ===========================
  -- Core Dependencies
  -- ===========================
  { "nvim-lua/popup.nvim" },
  { "nvim-lua/plenary.nvim" },
  { "nvim-tree/nvim-web-devicons" },

  -- ===========================
  -- UI & Navigation
  -- ===========================
  {
    "nvim-tree/nvim-tree.lua",
    lazy = false,
    priority = 1000,
    config = function()
      require("user.nvim-tree")
    end,
  },

  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    config = function()
      require("user.lualine")
    end,
  },

  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    config = function()
      require("user.alpha")
    end,
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      require("user.whichkey").setup()
    end,
  },

  {
    "akinsho/toggleterm.nvim",
    event = "VeryLazy",
    config = function()
      require("user.toggleterm").setup()
    end,
  },

  {
    "ahmedkhalf/project.nvim",
    event = "VeryLazy",
    config = function()
      require("user.project")
    end,
  },

  -- ===========================
  -- Editor Enhancements
  -- ===========================
  { "moll/vim-bbye" },
  { "tpope/vim-repeat" },
  { "mg979/vim-visual-multi" },
  { "christoomey/vim-tmux-navigator" },

  {
    "tzachar/highlight-undo.nvim",
    event = "BufReadPre",
    config = true,
  },

  {
    "nacro90/numb.nvim",
    event = "BufReadPre",
    config = function()
      require("user.numb").setup()
    end,
  },

  {
    "karb94/neoscroll.nvim",
    event = "VeryLazy",
    config = function()
      require("user.neoscroll").setup()
    end,
  },

  {
    "kevinhwang91/nvim-bqf",
    ft = "qf",
  },

  {
    "numToStr/Comment.nvim",
    event = "VeryLazy",
    config = function()
      require("user.comment").setup()
    end,
  },

  {
    "norcalli/nvim-colorizer.lua",
    event = "BufReadPre",
    config = function()
      require("user.colorizer")
    end,
  },


  -- ===========================
  -- Colorschemes
  -- ===========================
  { "tjdevries/colorbuddy.nvim" },
  { "lunarvim/darkplus.nvim" },
  { "Mofiqul/dracula.nvim" },
  { "svrana/neosolarized.nvim" },
  { "projekt0n/github-nvim-theme" },




  -- ===========================
  -- Completion & Snippets
  -- ===========================
  {
    "hrsh7th/nvim-cmp",
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-buffer",
      "https://codeberg.org/FelipeLema/cmp-async-path.git",
      "hrsh7th/cmp-cmdline",
      "rcarriga/cmp-dap",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
    },
    config = function()
      require("user.cmp")
    end,
  },

  {
    "L3MON4D3/LuaSnip",
    event = "InsertEnter",
    config = function()
      require("user.snippets")
    end,
  },

  {
    "rafamadriz/friendly-snippets",
    event = "InsertEnter",
  },

  -- ===========================
  -- Buffer & Session Management
  -- ===========================
  {
    "tiagovla/scope.nvim",
    event = "VeryLazy",
    config = function()
      require("scope").setup()
    end,
  },

  {
    "preservim/vimux",
    cmd = { "VimuxRunCommand", "VimuxTogglePane", "VimuxInterruptRunner", "VimuxOpenRunner" },
  },

  -- ===========================
  -- LSP & Language Support
  -- ===========================
  { "williamboman/mason.nvim" },
  { "williamboman/mason-lspconfig.nvim" },
  { "b0o/SchemaStore.nvim" },

  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    config = function()
      require("user.lsp")
    end,
  },

  {
    "folke/lazydev.nvim",
    ft = "lua",
    cmd = "LazyDev",
  },

  {
    "stevearc/conform.nvim",
    event = "VeryLazy",
    config = function()
      require("user.formatting").setup()
    end,
  },

  -- ===========================
  -- Telescope & Fuzzy Finding
  -- ===========================
  { "nvim-telescope/telescope-ui-select.nvim" },
  { "nvim-telescope/telescope-live-grep-args.nvim" },
  { "nvim-telescope/telescope-project.nvim" },
  { "nvim-telescope/telescope-smart-history.nvim" },
  { "kkharji/sqlite.lua" },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "make",
  },

  {
    "nvim-telescope/telescope.nvim",
    event = "VeryLazy",
    config = function()
      require("user.telescope").setup()
    end,
  },

  {
    "RRethy/vim-illuminate",
    event = "VeryLazy",
    config = function()
      require("user.illuminate").setup()
    end,
  },

  -- ===========================
  -- Treesitter & Syntax
  -- ===========================
  {
    "nvim-treesitter/nvim-treesitter",
    event = "BufReadPre",
    build = ":TSUpdate",
    dependencies = {
      "JoosepAlviste/nvim-ts-context-commentstring",
      "nvim-treesitter/nvim-treesitter-textobjects",
    },
    config = function()
      require("user.treesitter").setup()
    end,
  },

  {
    "HiPhish/rainbow-delimiters.nvim",
    event = "BufReadPre",
  },

  {
    "windwp/nvim-ts-autotag",
    event = "InsertEnter",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = true,
  },



  -- ===========================
  -- Git Integration
  -- ===========================
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    config = function()
      require("user.gitsigns").setup()
    end,
  },

  {
    "akinsho/git-conflict.nvim",
    event = "VeryLazy",
    config = true,
  },

  {
    "tpope/vim-fugitive",
    cmd = { "Git", "Gdiffsplit", "Gblame", "Gread", "Gwrite" },
  },

  require("user.diffview"),

  -- ===========================
  -- Code Navigation & Utilities
  -- ===========================
  {
    "ethanholz/nvim-lastplace",
    event = "BufReadPre",
    config = function()
      require("user.lastplace")
    end,
  },

  {
    "rmagatti/goto-preview",
    event = "BufReadPre",
    config = function()
      require("user.preview")
    end,
  },

  {
    "tpope/vim-eunuch",
    event = "BufReadPre",
  },

  {
    "folke/trouble.nvim",
    event = "VeryLazy",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("user.trouble").setup()
    end,
  },

  {
    "danymat/neogen",
    event = "BufReadPre",
    config = function()
      require("user.neogen").setup()
    end,
  },

  {
    "folke/todo-comments.nvim",
    event = "BufReadPre",
    config = function()
      require("user.todo-comments").setup()
    end,
  },

  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function()
      vim.fn["mkdp#util#install"]()
    end,
  },


  -- ===========================
  -- Debug Adapter Protocol (DAP)
  -- ===========================
  {
    "mfussenegger/nvim-dap",
    cmd = {
      "DapContinue", "DapToggleBreakpoint", "DapStepInto", "DapStepOver", "DapStepOut",
      "DapTerminate", "DapPause", "DapRestartFrame", "DapLoadLaunchJSON", "DapREPL"
    },
    keys = {
      "<leader>dt", "<leader>db", "<leader>dc", "<leader>dC", "<leader>dd",
      "<leader>dg", "<leader>di", "<leader>do", "<leader>du", "<leader>dp",
      "<leader>dr", "<leader>ds", "<leader>dq", "<leader>dU",
      "<F5>", "<F9>", "<F10>", "<F11>", "<F12>"
    },
    config = function()
      require("user.dap")
    end,
  },

  {
    "theHamsta/nvim-dap-virtual-text",
    event = "VeryLazy",
  },

  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    event = "VeryLazy",
  },

  {
    "mfussenegger/nvim-dap-python",
    event = "VeryLazy",
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    dependencies = { "williamboman/mason.nvim", "mfussenegger/nvim-dap" },
    event = "VeryLazy",
    config = function()
      require("mason-nvim-dap").setup()
    end,
  },

  -- ===========================
  -- UI & Status Components
  -- ===========================
  {
    "SmiteshP/nvim-navic",
    event = "VeryLazy",
    config = function()
      require("user.navic")
    end,
  },

  -- ===========================
  -- Utilities
  -- ===========================
  {
    "dstein64/vim-startuptime",
    cmd = "StartupTime",
  },

  { "tpope/vim-dadbod" },
  { "kristijanhusak/vim-dadbod-ui" },

  {
    "mbbill/undotree",
    keys = { -- load the plugin only when using its keybinding:
      { "<leader>u", "<cmd>UndotreeToggle<cr>" },
    },
  },



  -- ===========================
  -- AI & Copilot (Optional)
  -- ===========================
  require("user.copilot"),

  -- ===========================
  -- Additional Plugin Modules
  -- ===========================
  -- require("user.octo"),
  require("user.smartpairs"),
  require("user.mini-surround"),
  require("user.hardtime"),
})
