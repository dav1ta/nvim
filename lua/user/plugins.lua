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


tree= require("user.treesitter")
gitsigns= require("user.gitsigns")
trbl= require("user.trouble")
neogense= require("user.neogen")
tele= require("user.telescope")
illuminate= require("user.illuminate")
term= require("user.toggleterm")
which = require("user.whichkey")
numb = require("user.numb")
sig = require("user.lsp_signature")
comment = require ("user.comment")


-- Install your plugins here
return lazy.setup({
	-- My plugins here
	{"nvim-lua/popup.nvim"}, -- An implementation of the Popup API from vim in Neovim
	{"nvim-lua/plenary.nvim"}, -- Useful lua functions used ny lots of plugins
	{"nvim-tree/nvim-web-devicons"},
	{ "nvim-tree/nvim-tree.lua", event = "VeryLazy", config = function() require("user.nvim-tree") end },
	{"moll/vim-bbye"},
    { "nvim-lualine/lualine.nvim", event = "VeryLazy", config = function() require("user.lualine") end },
	{"akinsho/toggleterm.nvim",config=term.setup,event="VeryLazy"},
	{"ahmedkhalf/project.nvim", event = "VeryLazy", config = function() require("user.project") end },
	-- {"lukas-reineke/indent-blankline.nvim"},
	{"goolord/alpha-nvim", event = "VimEnter", config = function() require("user.alpha") end },
    {"folke/which-key.nvim",config=which.setup,event="VeryLazy",enabled=true},
	-- {"unblevable/quick-scope"},
	{"nacro90/numb.nvim",config=numb.setup,event="BufReadPre"},
	{"kevinhwang91/nvim-bqf", ft = "qf"},
	{"tpope/vim-repeat"},
	{"numToStr/Comment.nvim",config=comment.setup,event="VeryLazy"},
	{ "norcalli/nvim-colorizer.lua", event = "BufReadPre", config = function() require("user.colorizer") end },

	{"mg979/vim-visual-multi"},
  {"christoomey/vim-tmux-navigator"},
    {'tzachar/highlight-undo.nvim',config=true},


	-- Colorschemes
	-- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  {"tjdevries/colorbuddy.nvim"},
	{"lunarvim/darkplus.nvim"},
  'Mofiqul/dracula.nvim',
  "svrana/neosolarized.nvim",
    "projekt0n/github-nvim-theme",




	-- cmp plugins
  {"hrsh7th/nvim-cmp" ,
	event = "InsertEnter",
    config = function() require("user.cmp") end,
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
  { "preservim/vimux", cmd = {"VimuxRunCommand","VimuxTogglePane","VimuxInterruptRunner","VimuxOpenRunner"} },
	-- snippets
	{ "L3MON4D3/LuaSnip", config = function() require("user.snippets") end }, --snippet engine
	"rafamadriz/friendly-snippets", -- a bunch of snippets to use

	-- LSP
  -- use built-in inlay hints on 0.11+
  "williamboman/mason.nvim",
  "williamboman/mason-lspconfig.nvim",
  {"ray-x/lsp_signature.nvim",event="BufReadPre",config=sig.setup},

  "b0o/SchemaStore.nvim" ,
  {"neovim/nvim-lspconfig", event = "BufReadPre", config = function() require("user.lsp") end }, -- enable LSP

  -- Formatting with conform.nvim
  { "stevearc/conform.nvim", event = "VeryLazy", config = function()
      require("user.formatting").setup()
    end },


    "nvim-telescope/telescope-ui-select.nvim",
    "nvim-telescope/telescope-live-grep-args.nvim",
    "nvim-telescope/telescope-project.nvim",
    "nvim-telescope/telescope-fzf-native.nvim", build = "make",
	{
		"nvim-telescope/telescope.nvim",
    config = tele.setup,
		event = "VeryLazy",
	},


   {"RRethy/vim-illuminate",config=illuminate.setup,event="VeryLazy"},

	-- {"andymass/vim-matchup",config=matchup.setup,event="InsertEnter",dependencies={
	-- 	"nvim-treesitter/nvim-treesitter"},
 --  },



	-- {"windwp/nvim-autopairs",event="InsertEnter",
 --      dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" }
 --    ,config=true}, -- Autopairs, integrates with both cmp and treesitter


	{"windwp/nvim-ts-autotag",event="InsertEnter",
      dependencies = { "nvim-treesitter/nvim-treesitter", "hrsh7th/nvim-cmp" }
    ,config=true}, -- aitotag, integrates with both cmp and treesitter

	-- Treesitter
	{
		"nvim-treesitter/nvim-treesitter",
		-- :run = ":TSUpdate",
    config = tree.setup,
    enabled = true,
    dependencies={
    "JoosepAlviste/nvim-ts-context-commentstring",
   "nvim-treesitter/nvim-treesitter-textobjects"
    },
	},

    { 'HiPhish/rainbow-delimiters.nvim' },



	-- Git
	{"lewis6991/gitsigns.nvim",config=gitsigns.setup,event="BufReadPre"},
	{"akinsho/git-conflict.nvim",event="VeryLazy",config=true},
    {"tpope/vim-fugitive", cmd = {"Git", "Gdiffsplit", "Gblame", "Gread", "Gwrite"}},

	-- removed vista.vim (old/slow); use Telescope LSP symbols instead
	{"luukvbaal/stabilize.nvim", event = "VeryLazy", config = function() require("user.stabilize") end }, --stabilize text when splitting
	{"ethanholz/nvim-lastplace", event = "BufReadPre", config = function() require("user.lastplace") end }, --open file in last curso pos
	{"rmagatti/goto-preview",event="BufReadPre", config = function() require("user.preview") end }, --preview goto
	{"tpope/vim-eunuch",event="BufReadPre"}, --unix coomands mkdir

	{"folke/trouble.nvim",config=trbl.setup,event="VeryLazy",dependencies={"nvim-tree/nvim-web-devicons"}}, --see problems in code
	{"danymat/neogen",config=neogense.setup,event="BufReadPre"}, --Annotation
	{ "folke/todo-comments.nvim", event = "BufReadPre", config = require("user.todo-comments").setup },
	-- {"Mephistophiles/surround.nvim",config=surround.setup,event="BufReadPre"},
   {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    ft = { "markdown" },
    build = function() vim.fn["mkdp#util#install"]() end,
},


	{ "mfussenegger/nvim-dap",
      cmd = {
        "DapContinue","DapToggleBreakpoint","DapStepInto","DapStepOver","DapStepOut",
        "DapTerminate","DapPause","DapRestartFrame","DapLoadLaunchJSON","DapREPL"
      },
      keys = {"<leader>dt","<leader>db","<leader>dc","<leader>dC","<leader>dd","<leader>dg","<leader>di","<leader>do","<leader>du","<leader>dp","<leader>dr","<leader>ds","<leader>dq","<leader>dU","<Up>","<Down>","<Left>","<Right>"},
      config = function() require("user.dap") end
    },
	{ "theHamsta/nvim-dap-virtual-text", event = "VeryLazy" },
    { "rcarriga/nvim-dap-ui", dependencies = {"mfussenegger/nvim-dap", "nvim-neotest/nvim-nio"}, event = "VeryLazy" },
	{ "mfussenegger/nvim-dap-python", event = "VeryLazy" },
    {"jay-babu/mason-nvim-dap.nvim", dependencies = {"williamboman/mason.nvim", "mfussenegger/nvim-dap"}, event = "VeryLazy", config = function()
      require("mason-nvim-dap").setup()
    end},


  {"SmiteshP/nvim-navic",event="VeryLazy", config = function() require("user.navic") end },

  {"dstein64/vim-startuptime", cmd = "StartupTime"},

  "tpope/vim-dadbod",
  "kristijanhusak/vim-dadbod-ui",
{"mbbill/undotree", cmd = "UndotreeToggle"},



 -- {
 --    "zbirenbaum/copilot.lua",
 --    event = { "VimEnter" },
 --    config = function()
 --      vim.defer_fn(function()
 --        require("copilot").setup {
 --        }
 --      end, 100)
 --    end,
 --  },
 -- {
 --    "zbirenbaum/copilot-cmp",
 --    after = { "copilot.lua" },
 --    config = function()
 --      require("copilot_cmp").setup {
 --        formatters = {
 --          insert_text = require("copilot_cmp.format").remove_existing,
 --        },
 --      }
 --    end,
 --  },

    require("user.diffview"),
    require("user.octo"),
    require("user.telescope-tabs"),
    require("user.smartpairs"),
--require("user.codeium"),
    require("user.mini-surround"),
    require("user.hardtime"),
    require("user.copilot"),


})
