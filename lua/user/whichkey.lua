function setup()
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    print("which-key not found")
  return
end

local setup = {
  plugins = {
    marks = true, -- shows a list of your marks on ' and `
    registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
    spelling = {
      enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
      suggestions = 20, -- how many suggestions should be shown in the list?
    },
    -- the presets plugin, adds help for a bunch of default keybindings in Neovim
    -- No actual key bindings are created
    presets = {
      operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
      motions = true, -- adds help for motions
      text_objects = true, -- help for text objects triggered after entering an operator
      windows = true, -- default bindings on <c-w>
      nav = true, -- misc bindings to work with windows
      z = true, -- bindings for folds, spelling and others prefixed with z
      g = true, -- bindings for prefixed with g
    },
  },
  -- add operators that will trigger motion and text object completion
  -- to enable all native operators, set the preset / operators plugin above
  -- operators = { gc = "Comments" },
  icons = {
    breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
    separator = "➜", -- symbol used between a key and it's label
    group = "+", -- symbol prepended to a group
  },
  keys = {
    scroll_down = "<c-d>", -- binding to scroll down inside the popup
    scroll_up = "<c-u>", -- binding to scroll up inside the popup
  },
  win = {
    border = "rounded", -- none, single, double, shadow
    position = "bottom", -- bottom, top
    margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
    padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
    winblend = 0,
  },
  layout = {
    height = { min = 4, max = 25 }, -- min and max height of the columns
    width = { min = 20, max = 50 }, -- min and max width of the columns
    spacing = 3, -- spacing between columns
    align = "left", -- align columns left, center or right
  },
   filter = function(mapping)
    -- example to exclude mappings without a description
    -- return mapping.desc and mapping.desc ~= ""
    return true
  end,
  show_help = true, -- show help message on the command line when the popup is visible
  -- triggers = {"<leader>"} -- or specify a list manually
  triggers = {
    -- list of mode / prefixes that should never be hooked by WhichKey
    -- this is mostly relevant for key maps that start with a native binding
    -- most people should not need to change this
    -- i = { "j", "k" },
    -- v = { "j", "k" },
    -- n = { "'", '"' },
  },
}

local opts = {
  mode = "n", -- NORMAL mode
  prefix = "<leader>",
  buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
  silent = true, -- use `silent` when creating keymaps
  noremap = true, -- use `noremap` when creating keymaps
  nowait = true, -- use `nowait` when creating keymaps
}

local mappings = {
  { "<leader>a", "<cmd>Alpha<cr>", desc = "Alpha" },
  { "<leader>w", "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({layout_config={width=0.7}}))<cr>", desc = "Buffers" },
  { "<leader>e", "<cmd>NvimTreeToggle<cr>", desc = "Explorer" },
  { "<leader>/", '<cmd>Telescope current_buffer_fuzzy_find<CR>', desc = "Search" },
  { "<leader>h", "<cmd>nohlsearch<CR>", desc = "No Highlight" },
  { "<leader>R", '<cmd>lua require("renamer").rename()<cr>', desc = "Rename" },
  { "<leader>F", "<cmd>Telescope live_grep_args<cr>", desc = "Find Text" },
  { "<leader>P", "<cmd>lua require('telescope').extensions.projects.projects()<cr>", desc = "Projects" },
  { "<leader>f", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>", desc = "Find files" },
  { "<leader>5", "<cmd>RunProject <cr>", desc = "Run" },
  { "<leader>6", "<cmd>RunProject debug; lua require'dap'.continue()<cr>", desc = "Debug" },
  { "<leader>t", "<cmd>VimuxTogglePane <cr>", desc = "Toggle Pane" },
  { "<leader>j", "<cmd>VimuxInspectRunner <cr>", desc = "Inspect Runner" },
  { "<leader>r", "<cmd>BufferLineCyclePrev<cr>", desc = "Prev Tag" },

  { "<leader>g", group = "Git" },
  { "<leader>gg", "<cmd>lua _LAZYGIT_TOGGLE()<CR>", desc = "Lazygit" },
  { "<leader>gj", "<cmd>lua require 'gitsigns'.next_hunk()<cr>", desc = "Next Hunk" },
  { "<leader>gk", "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", desc = "Prev Hunk" },
  { "<leader>gl", "<cmd>GitBlameToggle<cr>", desc = "Blame" },
  { "<leader>gp", "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", desc = "Preview Hunk" },
  { "<leader>gr", "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", desc = "Reset Hunk" },
  { "<leader>gR", "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", desc = "Reset Buffer" },
  { "<leader>gs", "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", desc = "Stage Hunk" },
  { "<leader>gu", "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>", desc = "Undo Stage Hunk" },
  { "<leader>go", "<cmd>Telescope git_status<cr>", desc = "Open changed file" },
  { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
  { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Checkout commit" },
  { "<leader>gd", "<cmd>Gitsigns diffthis HEAD<cr>", desc = "Diff" },

  { "<leader>l", group = "LSP" },
  { "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", desc = "Code Action" },
  { "<leader>lb", "<cmd>lua require('lsp_lines').toggle()<cr>", desc = "Toggle lines" },
  { "<leader>ld", "<cmd>Telescope lsp_document_diagnostics<cr>", desc = "Document Diagnostics" },
  { "<leader>lw", "<cmd>Telescope lsp_workspace_diagnostics<cr>", desc = "Workspace Diagnostics" },
  { "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", desc = "Format" },
  { "<leader>li", "<cmd>LspInfo<cr>", desc = "Info" },
  { "<leader>lI", "<cmd>LspInstallInfo<cr>", desc = "Installer Info" },
  { "<leader>lj", "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>", desc = "Next Diagnostic" },
  { "<leader>lk", "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>", desc = "Prev Diagnostic" },
  { "<leader>ll", "<cmd>lua vim.lsp.codelens.run()<cr>", desc = "CodeLens Action" },
  { "<leader>lq", "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", desc = "Quickfix" },
  { "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", desc = "Rename" },
  { "<leader>ls", "<cmd>Telescope lsp_document_symbols<cr>", desc = "Document Symbols" },
  { "<leader>lS", "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>", desc = "Workspace Symbols" },

  { "<leader>v", group = "Find" },
  { "<leader>vb", "<cmd>Telescope git_branches<cr>", desc = "Checkout branch" },
  { "<leader>vc", "<cmd>Telescope colorscheme<cr>", desc = "Colorscheme" },
  { "<leader>vf", "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>", desc = "Find files" },
  { "<leader>vt", "<cmd>Telescope live_grep theme=ivy<cr>", desc = "Find Text" },
  { "<leader>vh", "<cmd>Telescope help_tags<cr>", desc = "Help" },
  { "<leader>vi", "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>", desc = "Media" },
  { "<leader>vl", "<cmd>Telescope resume<cr>", desc = "Last Search" },
  { "<leader>vM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
  { "<leader>vr", "<cmd>Telescope oldfiles<cr>", desc = "Recent File" },
  { "<leader>vR", "<cmd>Telescope registers<cr>", desc = "Registers" },
  { "<leader>vk", "<cmd>Telescope keymaps<cr>", desc = "Keymaps" },
  { "<leader>vC", "<cmd>Telescope commands<cr>", desc = "Commands" },

  { "<leader>d", group = "Debug" },
  { "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", desc = "Breakpoint" },
  { "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", desc = "Continue" },
  { "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", desc = "Into" },
  { "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", desc = "Over" },
  { "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", desc = "Out" },
  { "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", desc = "Repl" },
  { "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", desc = "Last" },
  { "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", desc = "UI" },
  { "<leader>dx", "<cmd>lua require'dap'.terminate()<cr>", desc = "Exit" },
  { "<leader>dt", "<cmd>lua require('dap-python').test_method()", desc = "Test Method" },
  { "<leader>dk", "<cmd>lua require('dap-python').test_class()", desc = "Test Class" },
  { "<leader>ds", "<cmd>lua require('dap-python').debug_selection()", desc = "Debug Selection" },
}

which_key.setup(setup)
which_key.add(mappings, opts)
end
return {setup=setup}
