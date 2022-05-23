local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
	return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
	return
end

dapui.setup {
  icons = { expanded = "▾", collapsed = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  sidebar = {
    -- You can change the order of elements in the sidebar
    elements = {
      -- Provide as ID strings or tables with "id" and "size" keys
      {
        id = "scopes",
        size = 0.25, -- Can be float or integer > 1
      },
      { id = "breakpoints", size = 0.25 },
      -- { id = "stacks", size = 0.25 },
      -- { id = "watches", size = 00.25 },
    },
    size = 40,
    position = "right", -- Can be "left", "right", "top", "bottom"
  },
  tray = {
    elements = {},
    -- elements = { "repl" },
    -- size = 10,
    -- position = "bottom", -- Can be "left", "right", "top", "bottom"
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "rounded", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
}

local icons = require "user.icons"

vim.fn.sign_define('DapBreakpoint', {text=icons.ui.Bug, texthl='DiagnosticSignError', linehl='', numhl=''})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end


require('dap-python').setup('~/Desktop/env/bin/python')
require('dap-python').test_runner = 'pytest'



-- require("nvim-dap-virtual-text").setup {
--     enabled = true,                        -- enable this plugin (the default)
--     enabled_commands = true,               -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
--     highlight_changed_variables = true,    -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
--     highlight_new_as_changed = false,      -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
--     show_stop_reason = true,               -- show stop reason when stopped for exceptions
--     commented = false,                     -- prefix virtual text with comment string
--     only_first_definition = true,          -- only show virtual text at first definition (if there are multiple)
--     all_references = false,                -- show virtual text on all all references of the variable (not only definitions)
--     filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
--     -- experimental features:
--     virt_text_pos = 'eol',                 -- position of virtual text, see `:h nvim_buf_set_extmark()`
--     all_frames = false,                    -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
--     virt_lines = false,                    -- show virtual lines instead of virtual text (will flicker!)
--     virt_text_win_col = nil                -- position the virtual text at a fixed window column (starting from the first text column) ,
--                                            -- e.g. 80 to position at column 80, see `:h nvim_buf_set_extmark()`
-- }

-- nnoremap <silent> <leader>dxz :lua require('dap-python').test_method()<CR>
-- nnoremap <silent> <leader>dvz :lua require('dap-python').test_class()<CR>
-- vnoremap <silent> <leader>dsz <ESC>:lua require('dap-python').debug_selection()<CR>
