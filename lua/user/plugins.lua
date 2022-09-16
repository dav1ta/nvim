local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath("data") .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
	PACKER_BOOTSTRAP = fn.system({
		"git",
		"clone",
		"--depth",
		"1",
		"https://github.com/wbthomason/packer.nvim",
		install_path,
	})
	print("Installing packer close and reopen Neovim...")
	vim.cmd([[packadd packer.nvim]])
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
	return
end

-- Have packer use a popup window
packer.init({
	display = {
		open_fn = function()
			return require("packer.util").float({ border = "rounded" })
		end,
	},
})

-- Install your plugins here
return packer.startup(function(use)
	-- My plugins here
	use("wbthomason/packer.nvim") -- Have packer manage itself
	use("nvim-lua/popup.nvim") -- An implementation of the Popup API from vim in Neovim
	use("nvim-lua/plenary.nvim") -- Useful lua functions used ny lots of plugins
	use("windwp/nvim-autopairs") -- Autopairs, integrates with both cmp and treesitter
	use("kyazdani42/nvim-web-devicons")
	use("kyazdani42/nvim-tree.lua")
	use("akinsho/bufferline.nvim")
	use("moll/vim-bbye")
	use("nvim-lualine/lualine.nvim")
	use("akinsho/toggleterm.nvim")
	use("ahmedkhalf/project.nvim")
	use("lewis6991/impatient.nvim")
	use("lukas-reineke/indent-blankline.nvim")
	use("goolord/alpha-nvim")
	use("antoinemadec/FixCursorHold.nvim") -- This is needed to fix lsp doc highlight
	use("folke/which-key.nvim")
	use("unblevable/quick-scope")
	use("andymass/vim-matchup")
	use("nacro90/numb.nvim")
	use("folke/zen-mode.nvim")
	use("karb94/neoscroll.nvim")
	use("kevinhwang91/nvim-bqf")
	use("tpope/vim-repeat")
	use("tversteeg/registers.nvim")
	use("filipdutescu/renamer.nvim")
	use("numToStr/Comment.nvim")
	use("norcalli/nvim-colorizer.lua")

	use("mg979/vim-visual-multi")

	-- Colorschemes
	-- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
	use("lunarvim/darkplus.nvim")
	use({ "dav1ta/darcula-solid.nvim", requires = "rktjmp/lush.nvim" })
  use 'srcery-colors/srcery-vim'
  use 'Mofiqul/dracula.nvim'

	-- cmp plugins
	use("hrsh7th/nvim-cmp") -- The completion plugin
	use("hrsh7th/cmp-buffer") -- buffer completions
	use("hrsh7th/cmp-path") -- path completions
	use("hrsh7th/cmp-cmdline") -- cmdline completions
	use("rcarriga/cmp-dap")
	use("saadparwaiz1/cmp_luasnip") -- snippet completions
	use("hrsh7th/cmp-nvim-lsp")
	use({

		"tiagovla/scope.nvim",
		config = function()
			require("scope").setup()
		end,
	})

	use("preservim/vimux")
	-- snippets
	use("L3MON4D3/LuaSnip") --snippet engine
	use("rafamadriz/friendly-snippets") -- a bunch of snippets to use

	-- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "lvimuser/lsp-inlayhints.nvim"

  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters
  use "ray-x/lsp_signature.nvim"
  use "simrat39/symbols-outline.nvim"
  use "b0o/SchemaStore.nvim"  


  use "https://git.sr.ht/~whynothugo/lsp_lines.nvim"


  -- Telescope
	use({
		"nvim-telescope/telescope.nvim",
		requires = {

			"nvim-telescope/telescope-frecency.nvim",
			"nvim-telescope/telescope-project.nvim",
			"nvim-telescope/telescope-github.nvim",
			"nvim-telescope/telescope-ui-select.nvim",
			"nvim-telescope/telescope-live-grep-args.nvim",
		},
	})

	use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })


	-- Treesitter
	use({
		"nvim-treesitter/nvim-treesitter",
		run = ":TSUpdate",
	})
	use("JoosepAlviste/nvim-ts-context-commentstring")
	use("nvim-treesitter/nvim-treesitter-textobjects")
	use("theHamsta/nvim-treesitter-pairs")
	use("windwp/nvim-ts-autotag")


  use "p00f/nvim-ts-rainbow"

	use({
		"ghillb/cybu.nvim",
		branch = "v1.x", -- won't receive breaking changes
		-- branch = "main", -- timely updates
		requires = { "kyazdani42/nvim-web-devicons" }, --optional
	})

	-- Git
	use("lewis6991/gitsigns.nvim")
	use("https://github.com/rhysd/conflict-marker.vim")

	use("liuchengxu/vista.vim") -- left side function panel
	use("luukvbaal/stabilize.nvim") --stabilize text when splitting
	use("ethanholz/nvim-lastplace") --open file in last curso pos
	use("rmagatti/goto-preview") --preview goto
	use("tpope/vim-eunuch") --unix coomands mkdir

	use("folke/trouble.nvim") --see problems in code
	use("danymat/neogen") --Annotation
	use("folke/todo-comments.nvim")
	use("sindrets/diffview.nvim")
	use("Mephistophiles/surround.nvim")
	use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install" })

	--dap

	-- DAP
	use("mfussenegger/nvim-dap")
	use("theHamsta/nvim-dap-virtual-text")
	use("rcarriga/nvim-dap-ui")
	use("mfussenegger/nvim-dap-python")
	use("Pocco81/DAPInstall.nvim")

	-- Automatically set up your configuration after cloning packer.nvim
	-- Put this at the end after all plugins
	if PACKER_BOOTSTRAP then
		require("packer").sync()
	end
end)
