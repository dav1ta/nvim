local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath "data" .. "/site/pack/packer/start/packer.nvim"
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system {
    "git",
    "clone",
    "--depth",
    "1",
    "https://github.com/wbthomason/packer.nvim",
    install_path,
  }
  print "Installing packer close and reopen Neovim..."
  vim.cmd [[packadd packer.nvim]]
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]]

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init {
  display = {
    open_fn = function()
      return require("packer.util").float { border = "rounded" }
    end,
  },
}

-- Install your plugins here
return packer.startup(function(use)
  -- My plugins here
  use "wbthomason/packer.nvim" -- Have packer manage itself
  use "nvim-lua/popup.nvim" -- An implementation of the Popup API from vim in Neovim
  use "nvim-lua/plenary.nvim" -- Useful lua functions used ny lots of plugins
  use "windwp/nvim-autopairs" -- Autopairs, integrates with both cmp and treesitter
  use "numToStr/Comment.nvim" -- Easily comment stuff
  use "kyazdani42/nvim-web-devicons"
  use "kyazdani42/nvim-tree.lua"
  use "akinsho/bufferline.nvim"
  use "moll/vim-bbye"
  use "nvim-lualine/lualine.nvim"
  use "akinsho/toggleterm.nvim"
  use "ahmedkhalf/project.nvim"
  use "lewis6991/impatient.nvim"
  use "lukas-reineke/indent-blankline.nvim"
  use "goolord/alpha-nvim"
  use "antoinemadec/FixCursorHold.nvim" -- This is needed to fix lsp doc highlight
  use "folke/which-key.nvim"
  use "unblevable/quick-scope"
  use "andymass/vim-matchup"
    use "nacro90/numb.nvim"
    use "folke/zen-mode.nvim"
    use "karb94/neoscroll.nvim"
    use "kevinhwang91/nvim-bqf"
    use "lunarvim/vim-solidity"
    use "tpope/vim-repeat"
    use "tversteeg/registers.nvim"
    use "nyngwang/NeoZoom.lua"
  use "filipdutescu/renamer.nvim"
  use "ray-x/lsp_signature.nvim"

  -- Colorschemes
  -- use "lunarvim/colorschemes" -- A bunch of colorschemes you can try out
  use "lunarvim/darkplus.nvim"

  -- cmp plugins
  use "hrsh7th/nvim-cmp" -- The completion plugin
  use "hrsh7th/cmp-buffer" -- buffer completions
  use "hrsh7th/cmp-path" -- path completions
  use "hrsh7th/cmp-cmdline" -- cmdline completions
  use "saadparwaiz1/cmp_luasnip" -- snippet completions
  use "hrsh7th/cmp-nvim-lsp"
  use {
    "tzachar/cmp-tabnine",
    config = function()
      local tabnine = require "cmp_tabnine.config"
      tabnine:setup {
        max_lines = 1000,
        max_num_results = 20,
        sort = true,
        run_on_every_keystroke = true,
        snippet_placeholder = "..",
        ignored_file_types = { -- default is not to ignore
          -- uncomment to ignore in lua:
          -- lua = true
        },
      }
    end,

    run = "./install.sh",
    requires = "hrsh7th/nvim-cmp",
  }
  -- snippets
  use "L3MON4D3/LuaSnip" --snippet engine
  use "rafamadriz/friendly-snippets" -- a bunch of snippets to use

  -- LSP
  use "neovim/nvim-lspconfig" -- enable LSP
  use "williamboman/nvim-lsp-installer" -- simple to use language server installer
  use "tamago324/nlsp-settings.nvim" -- language server settings defined in json for
  use "jose-elias-alvarez/null-ls.nvim" -- for formatters and linters

  -- Telescope
   use({
            "nvim-telescope/telescope.nvim",
            requires = {
                "nvim-telescope/telescope-frecency.nvim",
                "nvim-telescope/telescope-project.nvim",
                "nvim-telescope/telescope-github.nvim",
                'nvim-telescope/telescope-live-grep-raw.nvim',
                "nvim-telescope/telescope-ui-select.nvim"
            },
        })

    use({ "nvim-telescope/telescope-fzf-native.nvim", run = "make" })

  -- Treesitter
  use {
    "nvim-treesitter/nvim-treesitter",
    run = ":TSUpdate",
  }
  use "JoosepAlviste/nvim-ts-context-commentstring"
  use  "theHamsta/nvim-treesitter-pairs"
    use "windwp/nvim-ts-autotag"

  -- Git
  use "lewis6991/gitsigns.nvim"
    use "https://github.com/rhysd/conflict-marker.vim"

  use "liuchengxu/vista.vim" -- left side function panel
  use "SmiteshP/nvim-gps" --below location on statusline


  use "luukvbaal/stabilize.nvim" --stabilize text when splitting 
  use "ethanholz/nvim-lastplace" --open file in last curso pos
  use "rmagatti/goto-preview" --preview goto
  use "tpope/vim-eunuch"  --unix coomands mkdir 

   use "folke/trouble.nvim" --see problems in code
   use "danymat/neogen" --see problems in code
   use "folke/todo-comments.nvim"
   use "sindrets/diffview.nvim"
   use "Shatur/neovim-session-manager"
   use "tpope/vim-surround"
  		use({ "iamcco/markdown-preview.nvim", run = "cd app && npm install" })
  -- Automatically set up your configuration after cloning packer.nvim
  -- Put this at the end after all plugins
  if PACKER_BOOTSTRAP then
    require("packer").sync()
  end
end)
