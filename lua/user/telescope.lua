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
       function()
            require('telescope.builtin').buffers({
                sort_lastused = true,   -- Enable MRU sorting
                previewer = true,       -- Enable previewer
            })
        end,      desc = "Find",
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
  function()
    local function get_visual_selection()
      vim.cmd('noau normal! "vy"') -- Yank selection to register "v"
      return vim.fn.getreg("v") -- Get value from register
    end

    local text = get_visual_selection()
    require("telescope").extensions.live_grep_args.live_grep_args({default_text = text})
  end,
  mode = "v",
  desc = "Find Selected Text",
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





require("telescope").setup({
  defaults = {
    vimgrep_arguments = {
      "rg",
      "--with-filename",
      "--no-heading",
      "--line-number",
      "--column",
      "--hidden",      -- Search hidden files
      "--no-ignore",   -- Don't respect .gitignore
      "--smart-case",  -- Case-sensitive only when uppercase is used
      "--follow",      -- Follow symlinks
      "--color=never",
      "--pcre2"        -- Better regex support
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
        ["<C-q>"] = actions.send_to_qflist + actions.open_qflist,
        ["<M-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
        ["<C-_>"] = actions.which_key, -- Show help
      },
      n = {
        ["<esc>"] = actions.close,
        ["<CR>"] = actions.select_default,
        ["<C-x>"] = actions.select_horizontal,
        ["<C-v>"] = actions.select_vertical,
        ["<C-t>"] = actions.select_tab,
        ["j"] = actions.move_selection_next,
        ["k"] = actions.move_selection_previous,
        ["gg"] = actions.move_to_top,
        ["G"] = actions.move_to_bottom,
        ["<C-u>"] = actions.preview_scrolling_up,
        ["<C-d>"] = actions.preview_scrolling_down,
        ["?"] = actions.which_key,
      },
    },
    prompt_prefix = "❯ ",
    selection_caret = " ",
    entry_prefix = "  ",
    initial_mode = "insert",
    selection_strategy = "reset",
    sorting_strategy = "ascending",
    layout_strategy = "horizontal",
    layout_config = {
      prompt_position = "top",
      horizontal = { mirror = false },
      vertical = { mirror = false },
    },
    file_ignore_patterns = { -- Exclude unnecessary files from search
      "node_modules/*",
      ".git/*",
      "dist/*",
      "vendor/*",
      "*.log",
      "*.min.js",
      "__pycache__/*",
    },
    file_sorter = require("telescope.sorters").get_fzy_sorter,
    file_previewer = require("telescope.previewers").vim_buffer_cat.new,
    grep_previewer = require("telescope.previewers").vim_buffer_vimgrep.new,
    qflist_previewer = require("telescope.previewers").vim_buffer_qflist.new,
    buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
  },
  pickers = {
    buffers = {
      theme = "dropdown",
      previewer = true,
      initial_mode = "normal",
      sort_lastused = true,
      mappings = {
        i = { ["<C-d>"] = actions.delete_buffer },
        n = { ["dd"] = actions.delete_buffer },
      },
    },
  },
  extensions = {
    fzf = {
      fuzzy = true,                   -- Enable fuzzy search
      override_generic_sorter = true,  -- Prioritize exact matches
      override_file_sorter = true,     -- Use fzf for file sorting
      case_mode = "smart_case",        -- Ignore case unless uppercase is used
    },
    project = {
      hidden_files = true,
      display_type = "full",
    },
    ["ui-select"] = {
      require("telescope.themes").get_dropdown({ previewer = true }),
    },
  }
})
-- telescope.load_extension("frecency")
telescope.load_extension("fzf")
-- telescope.load_extension("gh")
telescope.load_extension("project")
telescope.load_extension("ui-select")
telescope.load_extension("live_grep_args")

end
return {setup=setup}
