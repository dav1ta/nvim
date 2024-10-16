function setup()
local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    print("which-key not found")
  return
end



local st = {
    -- preset = "helix",
    plugins = {
      marks = true,
      registers = true,
      spelling = {
        enabled = true,
        suggestions = 20,
      },
      presets = {
        operators = false,
        motions = false,
        text_objects = false,
        windows = false,
        nav = false,
        z = false,
        g = false,
      },
    },
    delay = 100,
    win = {
      border = "rounded",
      no_overlap = false,
      padding = { 1, 2 }, -- extra window padding [top/bottom, right/left]
      title = false,
      title_pos = "center",
      zindex = 1000,
    },
    -- ignore_missing = true,
    show_help = false,
    show_keys = false,
    disable = {
      buftypes = {},
      filetypes = { "TelescopePrompt" },
    },
  }



-- local opts = {
--   mode = "n", -- NORMAL mode
--   prefix = "<leader>",
--   buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
--   silent = true, -- use `silent` when creating keymaps
--   noremap = true, -- use `noremap` when creating keymaps
--   nowait = true, -- use `nowait` when creating keymaps
-- }

-- local mappings = {
--   ["a"] = { "<cmd>Alpha<cr>", "Alpha" },
--   ["w"] = {
--     "<cmd>lua require('telescope.builtin').buffers(require('telescope.themes').get_dropdown({layout_config={width=0.7}}))<cr>",
--     "Buffers",
--   },

--   ["e"] = { "<cmd>NvimTreeToggle<cr>", "Explorer" },
--   -- ["w"] = { "<cmd>w!<CR>", "Save" },
--   -- ["q"] = { "<cmd>q!<CR>", "Quit" },
--     ["/"] = { '<cmd>Telescope current_buffer_fuzzy_find<CR>', "Search" },
--   --["c"] = { "<cmd>Bdelete!<CR>", "Close Buffer" },
--   ["h"] = { "<cmd>nohlsearch<CR>", "No Highlight" },
--    ["R"] = { '<cmd>lua require("renamer").rename()<cr>', "Rename" },
--   ["F"] = { "<cmd>Telescope live_grep_args<cr>", "Find Text" },
--   ["P"] = { "<cmd>lua require('telescope').extensions.projects.projects()<cr>", "Projects" },
--   ["f"] = {
--       "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
--       "Find files",
--     },
--   ["5"] = {"<cmd>RunProject <cr>","Run"},
--   ["6"] = {"<cmd>RunProject debug; lua require'dap'.continue()<cr>","Debug"},

--   ["t"] = {"<cmd>VimuxTogglePane <cr>", "Toggle Pane"},
--   ["j"] = {"<cmd>VimuxInspectRunner <cr>", "Toggle Pane"},
--   ["r"] = {"<cmd>BufferLineCyclePrev<cr>", "Prev Tag"},



--   g = {
--     name = "Git",
--     g = { "<cmd>lua _LAZYGIT_TOGGLE()<CR>", "Lazygit" },
--     j = { "<cmd>lua require 'gitsigns'.next_hunk()<cr>", "Next Hunk" },
--     k = { "<cmd>lua require 'gitsigns'.prev_hunk()<cr>", "Prev Hunk" },
--     l = { "<cmd>GitBlameToggle<cr>", "Blame" },
--     p = { "<cmd>lua require 'gitsigns'.preview_hunk()<cr>", "Preview Hunk" },
--     r = { "<cmd>lua require 'gitsigns'.reset_hunk()<cr>", "Reset Hunk" },
--     R = { "<cmd>lua require 'gitsigns'.reset_buffer()<cr>", "Reset Buffer" },
--     s = { "<cmd>lua require 'gitsigns'.stage_hunk()<cr>", "Stage Hunk" },
--     u = {
--       "<cmd>lua require 'gitsigns'.undo_stage_hunk()<cr>",
--       "Undo Stage Hunk",
--     },
--     o = { "<cmd>Telescope git_status<cr>", "Open changed file" },
--     b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
--     c = { "<cmd>Telescope git_commits<cr>", "Checkout commit" },
--     d = {
--       "<cmd>Gitsigns diffthis HEAD<cr>",
--       "Diff",
--     },
--   },

--   l = {
--     name = "LSP",
--     a = { "<cmd>lua vim.lsp.buf.code_action()<cr>", "Code Action" },
--     b = { "<cmd>lua require('lsp_lines').toggle()<cr>", "Toggle lines" },
--     d = {
--       "<cmd>Telescope lsp_document_diagnostics<cr>",
--       "Document Diagnostics",
--     },
--     w = {
--       "<cmd>Telescope lsp_workspace_diagnostics<cr>",
--       "Workspace Diagnostics",
--     },

--     f = { "<cmd>lua vim.lsp.buf.formatting()<cr>", "Format" },
--     i = { "<cmd>LspInfo<cr>", "Info" },
--     I = { "<cmd>LspInstallInfo<cr>", "Installer Info" },
--     j = {
--       "<cmd>lua vim.lsp.diagnostic.goto_next()<CR>",
--       "Next Diagnostic",
--     },
--     k = {
--       "<cmd>lua vim.lsp.diagnostic.goto_prev()<cr>",
--       "Prev Diagnostic",
--     },
--     l = { "<cmd>lua vim.lsp.codelens.run()<cr>", "CodeLens Action" },
--     q = { "<cmd>lua vim.lsp.diagnostic.set_loclist()<cr>", "Quickfix" },
--     r = { "<cmd>lua vim.lsp.buf.rename()<cr>", "Rename" },
--     s = { "<cmd>Telescope lsp_document_symbols<cr>", "Document Symbols" },
--     S = {
--       "<cmd>Telescope lsp_dynamic_workspace_symbols<cr>",
--       "Workspace Symbols",
--     },
--   },

--    v = {
--     name = "Find",
--     b = { "<cmd>Telescope git_branches<cr>", "Checkout branch" },
--     c = { "<cmd>Telescope colorscheme<cr>", "Colorscheme" },
--     f = {
--       "<cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown{previewer = false})<cr>",
--       "Find files",
--     },
--     t = { "<cmd>Telescope live_grep theme=ivy<cr>", "Find Text" },
--     h = { "<cmd>Telescope help_tags<cr>", "Help" },
--     i = { "<cmd>lua require('telescope').extensions.media_files.media_files()<cr>", "Media" },
--     l = { "<cmd>Telescope resume<cr>", "Last Search" },
--     M = { "<cmd>Telescope man_pages<cr>", "Man Pages" },
--     r = { "<cmd>Telescope oldfiles<cr>", "Recent File" },
--     R = { "<cmd>Telescope registers<cr>", "Registers" },
--     k = { "<cmd>Telescope keymaps<cr>", "Keymaps" },
--     C = { "<cmd>Telescope commands<cr>", "Commands" },
--   },


--    d = {
--     name = "Debug",
--     b = { "<cmd>lua require'dap'.toggle_breakpoint()<cr>", "Breakpoint" },
--     c = { "<cmd>lua require'dap'.continue()<cr>", "Continue" },
--     i = { "<cmd>lua require'dap'.step_into()<cr>", "Into" },
--     o = { "<cmd>lua require'dap'.step_over()<cr>", "Over" },
--     O = { "<cmd>lua require'dap'.step_out()<cr>", "Out" },
--     r = { "<cmd>lua require'dap'.repl.toggle()<cr>", "Repl" },
--     l = { "<cmd>lua require'dap'.run_last()<cr>", "Last" },
--     u = { "<cmd>lua require'dapui'.toggle()<cr>", "UI" },
--     x = { "<cmd>lua require'dap'.terminate()<cr>", "Exit" },
--     t = { "<cmd>lua require('dap-python').test_method()", "Test Method" },
--     k = { "<cmd>lua require('dap-python').test_class()", "Test Class" },
--     s = { "<cmd>lua require('dap-python').debug_selection()", "Debug Selection" },
--   },

-- }

which_key.setup(st)
-- which_key.register(mappings, opts)
 which_key.add {
    {
      "<leader>a",
      group = "AI",
      icon = {
        icon = " ",
        color = "blue",
      },
    },
    {
      "<leader>q",
      "<cmd>confirm q<CR>",
      desc = "Quit",
    },
    {
      "<leader>h",
      "<cmd>nohlsearch<CR>",
      desc = "NOHL",
      hidden = true,
    },
    {
      "<leader>;",
      "<cmd>tabnew | terminal<CR>",
      desc = "Term",
      icon = {
        icon = " ",
        color = "green",
      },
    },
    {
      "<leader>w",
      "<cmd>lua vim.wo.wrap = not vim.wo.wrap<CR>",
      desc = "Wrap",
      hidden = true,
    },
    {
      "<leader>v",
      "<cmd>vsplit<CR>",
      desc = "Split",
      hidden = true,
    },
    {
      "<leader>b",
      group = "Buffers",
    },
    {
      "<leader>d",
      group = "Debug",
    },
    {
      "<leader>f",
      group = "Find",
    },
    {
      "<leader>g",
      group = "Git",
    },
    {
      "<leader>l",
      group = "LSP",
      icon = {
        icon = " ",
        color = "blue",
      },
    },
    {
      "<leader>n",
      icon = {
        icon = "󱞂 ",
        color = "yellow",
      },
      group = "Nostr",
    },
    {
      "<leader>p",
      icon = {
        icon = " ",
        color = "azure",
      },
      group = "Plugins",
    },
    {
      "<leader>t",
      group = "Test",
    },
    -- {
    --   "<leader>a",
    --   name = "Tab",
    --   children = {
    --     {
    --       "<leader>an",
    --       "<cmd>$tabnew<cr>",
    --       desc = "New Empty Tab",
    --     },
    --     {
    --       "<leader>aN",
    --       "<cmd>tabnew %<cr>",
    --       desc = "New Tab",
    --     },
    --     {
    --       "<leader>ao",
    --       "<cmd>tabonly<cr>",
    --       desc = "Only",
    --     },
    --     {
    --       "<leader>ah",
    --       "<cmd>-tabmove<cr>",
    --       desc = "Move Left",
    --     },
    --     {
    --       "<leader>al",
    --       "<cmd>+tabmove<cr>",
    --       desc = "Move Right",
    --     },
    --   },
    -- },
    {
      "<leader>T",
      group = "Treesitter",
    },
  }



end
return {setup=setup}
