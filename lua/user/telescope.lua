function setup()
local status_ok, telescope = pcall(require, "telescope")
if not status_ok then
    print("telescope not found")
	return
end

local actions = require("telescope.actions")


  local wk = require "which-key"

  wk.add {
    {
      "<leader>w",
      "<cmd>Telescope buffers previewer=true<cr>",
      desc = "Find",
    },
    {
      "<leader>tb",
      "<cmd>Telescope git_branches<cr>",
      desc = "Checkout branch",
    },
    {
      "<leader>tc",
      "<cmd>Telescope colorscheme<cr>",
      desc = "Colorscheme",
    },
    {
      "<leader>f",
      "<cmd>Telescope find_files<cr>",
      desc = "Find files",
    },
    {
      "<leader>tp",
      "<cmd>lua require('telescope').extensions.projects.projects()<cr>",
      desc = "Projects",
    },
    {
      "<leader>F",
      "<cmd>Telescope live_grep_args<cr>",
      desc = "Find Text",
    },
    {
      "<leader>ts",
      "<cmd>Telescope grep_string<cr>",
      desc = "Find String",
    },
    {
      "<leader>th",
      "<cmd>Telescope help_tags<cr>",
      desc = "Help",
    },
    {
      "<leader>ti",
      "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>",
      desc = "Media",
    },
    {
      "<leader>tl",
      "<cmd>Telescope resume<cr>",
      desc = "Last Search",
    },
    {
      "<leader>tM",
      "<cmd>Telescope man_pages<cr>",
      desc = "Man Pages",
    },
    {
      "<leader>tr",
      "<cmd>Telescope oldfiles<cr>",
      desc = "Recent File",
    },
    {
      "<leader>tR",
      "<cmd>Telescope registers<cr>",
      desc = "Registers",
    },
    {
      "<leader>tk",
      "<cmd>Telescope keymaps<cr>",
      desc = "Keymaps",
    },
    {
      "<leader>tC",
      "<cmd>Telescope commands<cr>",
      desc = "Commands",
    },
    {
      "<leader>go",
      "<cmd>Telescope git_status<cr>",
      desc = "Open changed file",
    },
    {
      "<leader>gb",
      "<cmd>Telescope git_branches<cr>",
      desc = "Checkout branch",
    },
    {
      "<leader>gc",
      "<cmd>Telescope git_commits<cr>",
      desc = "Checkout commit",
    },
    {
      "<leader>gC",
      "<cmd>Telescope git_bcommits<cr>",
      desc = "Checkout commit(for current file)",
    },
    {
      "<leader>ls",
      "<cmd>Telescope lsp_document_symbols<cr>",
      desc = "Document Symbols",
    },
    {
      "<leader>lS",
      "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
      desc = "Workspace Symbols",
    },
    {
      "<leader>le",
      "<cmd>Telescope quickfix<cr>",
      desc = "Telescope Quickfix",
    },
  }





telescope.setup({
	defaults = {
		vimgrep_arguments = {
			"rg",
			"--with-filename",
			"--no-heading",
			"--line-number",
			"--column",
			"--hidden",
            "--no-ignore",
			"--smart-case",
			"--follow",
			"--color=never",
		},
		mappings = {
			i = {
				["<C-n>"] = actions.cycle_history_next,
				["<C-p>"] = actions.cycle_history_prev,

				["<C-j>"] = actions.move_selection_next,
				["<C-k>"] = actions.move_selection_previous,

				["<C-c>"] = actions.close,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,

				["<CR>"] = actions.select_default,
				["<C-s>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<c-d>"] = require("telescope.actions").delete_buffer,

				-- ["<C-u>"] = actions.preview_scrolling_up,
				-- ["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
				["<C-l>"] = actions.complete_tag,
				["<C-_>"] = actions.which_key, -- keys from pressing <C-/>
			},

			n = {
				["<esc>"] = actions.close,
				["<CR>"] = actions.select_default,
				["<C-x>"] = actions.select_horizontal,
				["<C-v>"] = actions.select_vertical,
				["<C-t>"] = actions.select_tab,

				["<Tab>"] = actions.toggle_selection + actions.move_selection_worse,
				["<S-Tab>"] = actions.toggle_selection + actions.move_selection_better,
				["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
				["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,

				["j"] = actions.move_selection_next,
				["k"] = actions.move_selection_previous,
				["H"] = actions.move_to_top,
				["M"] = actions.move_to_middle,
				["L"] = actions.move_to_bottom,

				["<Down>"] = actions.move_selection_next,
				["<Up>"] = actions.move_selection_previous,
				["gg"] = actions.move_to_top,
				["G"] = actions.move_to_bottom,

				["<C-u>"] = actions.preview_scrolling_up,
				["<C-d>"] = actions.preview_scrolling_down,

				["<PageUp>"] = actions.results_scrolling_up,
				["<PageDown>"] = actions.results_scrolling_down,

				["?"] = actions.which_key,
			},
		},
		dynamic_preview_title = false,
		prompt_prefix = "❯ ",
		-- prompt_prefix = " ",
		selection_caret = " ",
		entry_prefix = "  ",
		initial_mode = "insert",
		selection_strategy = "reset",
		sorting_strategy = "ascending",
		-- layout_config = {
		--   horizontal = {
		--     preview_width = 0.6,
		--   },
		-- },
		layout_strategy = "flex",
		layout_config = {
			horizontal = { width = 0.95, height = 0.95, preview_width = 0.5 },
			vertical = { width = 0.95, height = 0.95, preview_height = 0.7 },
			-- horizontal = {
			--   prompt_position = "bottom",
			--   preview_width = 0.55,
			-- },
			-- vertical = {
			--   mirror = false,
			-- },
			-- width = 0.87,
			-- height = 0.80,
			-- preview_cutoff = 120,
		},

         buffers = {
            theme = "dropdown",
            previewer = true,
            initial_mode = "normal",
            sort_by = function(a, b)
                    local path_a = vim.fn.expand(a.path) -- Get the full path of buffer A
                    local path_b = vim.fn.expand(b.path) -- Get the full path of buffer B
                    return path_a < path_b -- Sort alphabetically by file path
                  end,
            sort_mru = false, -- Disable MRU sorting
            sort_lastused = false,
            mappings = {
              i = {
                ["<C-d>"] = actions.delete_buffer,
              },
              n = {
                ["dd"] = actions.delete_buffer,
              },
            },
      },
		-- layout_strategy = "horizontal",
		-- layout_config = {
		--     horizontal = {
		--         prompt_position = "top",
		--         preview_width = 0.55,
		--         results_width = 0.8,
		--     },
		--     vertical = { mirror = false },
		--     width = 0.87,
		--     height = 0.80,
		--     preview_cutoff = 120,
		-- },
		-- layout_config = {horizontal = {mirror = false}, vertical = {mirror = false}},
		file_sorter = require("telescope.sorters").get_fzy_sorter,
		file_previewer = require("telescope.previewers").vim_buffer_cat.new,
		grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
		qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
		buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
		-- file_ignore_patterns = {
		-- 	"%.gif",
		-- 	"%.jpeg",
		-- 	"%.jpg",
		-- 	"%.ods",
		-- 	"%.odt",
		-- 	"%.pdf",
		-- 	"%.png",
		-- 	"%.svg",
		-- 	"%.xcf",
		-- 	"%.xls",
		-- 	"%.zcompdump",
		-- 	".bloop",
		-- 	".dropbox%-dist/",
		-- 	".git/*",
		-- 	".jfrog/",
		-- 	".m2",
		-- 	".metals",
		-- 	".metals/*",
		-- 	".mozilla/",
		-- 	".vscode/",
		-- 	".zoom/",
		-- 	"Downloads",
		-- 	"ScalaResources",
		-- 	"ScalaResources/",
		-- 	"^lua-language-server/",
		-- 	"cache",
		-- 	"gif",
		-- 	"jpeg",
		-- 	"jpg",
		-- 	"lua-language-server",
		-- 		},
		winblend = 15,
		border = {},
		color_devicons = false,
		use_less = true,
		set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
	},
	extensions = {
		fzf = {
			fuzzy = true, -- false will only do exact matching
			override_generic_sorter = true, -- overrde the generic sorter
			override_file_sorter = true, -- override the file sorter
			case_mode = "ignore_case", -- or "ignore_case" or "respect_case"
		},
		-- media_files = {
		--     filetypes = { "png", "webp", "jpg", "jpeg" },
		--     find_cmd = "rg",
		-- },
		-- apparently this would control where telescope opens the preview
		project = {
			-- base_dirs = {'~/dev'},
			hidden_files = true,
			display_type = "full",
		},
		["ui-select"] = {
			require("telescope.themes").get_dropdown({
				previewer = false,
				-- even more opts
			}),
		},
	},
})
-- telescope.load_extension("frecency")
telescope.load_extension("fzf")
-- telescope.load_extension("gh")
telescope.load_extension("project")
telescope.load_extension("ui-select")
telescope.load_extension("live_grep_args")

end
return {setup=setup}
