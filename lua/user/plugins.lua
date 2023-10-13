local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
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

vim.g.mapleader= " "
vim.g.maplocalleader= " "



-- Autocommand that reloads neovim whenever you save the plugins.lua file
-- Use a protected call so we don't error out on first use
local status_ok, lazy = pcall(require, "lazy")
if not status_ok then
	return
end


tree= require("user.treesitter")
gitsigns= require("user.gitsigns")
trbl= require("user.trouble")
neogense= require("user.neogen")
tele= require("user.telescope")
illuminate= require("user.illuminate")
-- matchup= require("user.matchup")
surround= require("user.surround")
term= require("user.toggleterm")
which = require("user.whichkey")
numb = require("user.numb")
sig = require("user.lsp_signature")
-- autopairs = require ("user.autopairs")
comment = require ("user.comment")


-- Install your plugins here
return lazy.setup({
	-- My plugins here
	{"nvim-lua/popup.nvim"}, -- An implementation of the Popup API from vim in Neovim
	{"nvim-lua/plenary.nvim"}, -- Useful lua functions used ny lots of plugins
	{"kyazdani42/nvim-web-devicons"},
	{"kyazdani42/nvim-tree.lua"},
	{"moll/vim-bbye"},
	{"nvim-lualine/lualine.nvim"},
	{"akinsho/toggleterm.nvim",config=term.setup,event="BufReadPost"},
	{"ahmedkhalf/project.nvim"},
	{"lewis6991/impatient.nvim"},
	-- {"lukas-reineke/indent-blankline.nvim"},
	{"goolord/alpha-nvim"},
	{"antoinemadec/FixCursorHold.nvim"}, -- This is needed to fix lsp doc highlight
	{"folke/which-key.nvim",config=which.setup,event="VeryLazy"},
	-- {"unblevable/quick-scope"},
	{"nacro90/numb.nvim",config=numb.setup,event="BufReadPre"},
	{"kevinhwang91/nvim-bqf"},
	{"tpope/vim-repeat"},
	{"numToStr/Comment.nvim",config=comment.setup,event="BufReadPost"},
	{"norcalli/nvim-colorizer.lua"},

	{"mg979/vim-visual-multi"},
  {"christoomey/vim-tmux-navigator"},


	-- Colorschemes
	-- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  {"tjdevries/colorbuddy.nvim"},
	{"lunarvim/darkplus.nvim"},
  'Mofiqul/dracula.nvim',
  "svrana/neosolarized.nvim",




	-- cmp plugins
  {"hrsh7th/nvim-cmp" ,
	dependencies = {
  "hrsh7th/cmp-buffer",
	"hrsh7th/cmp-path" ,
	"hrsh7th/cmp-cmdline",
	"rcarriga/cmp-dap",
	"saadparwaiz1/cmp_luasnip", -- snippet completions
	"hrsh7th/cmp-nvim-lsp",
    },
  --  config = comp.setup
  },


	{

		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup()
		end,
	},
  "preservim/vimux",
	-- snippets
	"L3MON4D3/LuaSnip", --snippet engine
	"rafamadriz/friendly-snippets", -- a bunch of snippets to use

	-- LSP
  "lvimuser/lsp-inlayhints.nvim",
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  "jose-elias-alvarez/null-ls.nvim", -- for formatters and linters
  {"ray-x/lsp_signature.nvim",event="BufReadPre",config=sig.setup},

  "simrat39/symbols-outline.nvim",
  "b0o/SchemaStore.nvim" ,
  "neovim/nvim-lspconfig", -- enable LSP

    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "nvim-telescope/telescope-project.nvim",
    "nvim-telescope/telescope-fzf-native.nvim", run = "make",
	{
		"nvim-telescope/telescope.nvim",
    config = tele.setup,
		event = "InsertEnter",
	},


   {"RRethy/vim-illuminate",config=illuminate.setup,event="BufReadPost"},

	-- {"andymass/vim-matchup",config=matchup.setup,event="InsertEnter",dependencies={
	-- 	"nvim-treesitter/nvim-treesitter"},
 --  },


	-- {"windwp/nvim-autopairs",event="InsertEnter",
 --      dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" }
 --    ,config=autopairs.setup}, -- Autopairs, integrates with both cmp and treesitter

    {
    'altermo/ultimate-autopair.nvim',
    event={'InsertEnter','CmdlineEnter'},
    branch='v0.6',
    opts={
        --Config goes here
    },
        },
	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		-- :run = ":TSUpdate",
    config = tree.setup,
    enabled = true,
    dependencies={"windwp/nvim-ts-autotag",
    "mrjones2014/nvim-ts-rainbow",
    "JoosepAlviste/nvim-ts-context-commentstring",
    "nvim-treesitter/nvim-treesitter-textobjects"},
	},


	-- Git
	{"lewis6991/gitsigns.nvim",config=gitsigns.setup,event="BufReadPre"},
	{"akinsho/git-conflict.nvim",event="BufReadPost",config=true},
    {"tpope/vim-fugitive"},

	{"liuchengxu/vista.vim",event="BufReadPre"}, -- left side function panel
	{"luukvbaal/stabilize.nvim"}, --stabilize text when splitting
	{"ethanholz/nvim-lastplace"}, --open file in last curso pos
	{"rmagatti/goto-preview",event="BufReadPre"}, --preview goto
	{"tpope/vim-eunuch",event="BufReadPre"}, --unix coomands mkdir

	{"folke/trouble.nvim",config=trbl.setup,event="BufReadPost",depnedencies={'gitsigns'}}, --see problems in code
	{"danymat/neogen",config=neogense.setup,event="BufReadPre"}, --Annotation
	{"folke/todo-comments.nvim",event="BufReadPre"},
	{"Mephistophiles/surround.nvim",config=surround.setup,event="BufReadPre"},
	{ "iamcco/markdown-preview.nvim", run = "cd app && npm install" },

	--dap

	-- DAP
	{"mfussenegger/nvim-dap"},
	{"theHamsta/nvim-dap-virtual-text"},
	{"rcarriga/nvim-dap-ui"},
	{"mfussenegger/nvim-dap-python"},
	{"Pocco81/DAPInstall.nvim"},


  {"SmiteshP/nvim-navic",event="BufReadPost"},

  "dstein64/vim-startuptime",

  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-ui",
"mbbill/undotree",



 {
    "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup {
        }
      end, 100)
    end,
  },
 {
    "zbirenbaum/copilot-cmp",
    after = { "copilot.lua" },
    config = function()
      require("copilot_cmp").setup {
        formatters = {
          insert_text = require("copilot_cmp.format").remove_existing,
        },
      }
    end,
  },


})
