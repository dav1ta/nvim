local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then
  print("dap not found")
  return
end

local dap_ui_status_ok, dapui = pcall(require, "dapui")
if not dap_ui_status_ok then
  print("dapui not found")
  return
end

local wk = require "which-key"

wk.add {
  {
    "<leader>dt",
    "<cmd>lua require'dap'.toggle_breakpoint()<cr>",
    desc = "Toggle Breakpoint",
  },
  {
    "<leader>db",
    "<cmd>lua require'dap'.step_back()<cr>",
    desc = "Step Back",
  },
  {
    "<leader>dc",
    "<cmd>lua require'dap'.continue()<cr>",
    desc = "Continue",
  },
  {
    "<leader>dC",
    "<cmd>lua require'dap'.run_to_cursor()<cr>",
    desc = "Run To Cursor",
  },
  {
    "<leader>dd",
    "<cmd>lua require'dap'.disconnect()<cr>",
    desc = "Disconnect",
  },
  {
    "<leader>dg",
    "<cmd>lua require'dap'.session()<cr>",
    desc = "Get Session",
  },
  {
    "<leader>di",
    "<cmd>lua require'dap'.step_into()<cr>",
    desc = "Step Into",
  },
  {
    "<leader>do",
    "<cmd>lua require'dap'.step_over()<cr>",
    desc = "Step Over",
  },
  {
    "<leader>du",
    "<cmd>lua require'dap'.step_out()<cr>",
    desc = "Step Out",
  },
  {
    "<leader>dp",
    "<cmd>lua require'dap'.pause()<cr>",
    desc = "Pause",
  },
  {
    "<leader>dr",
    "<cmd>lua require'dap'.repl.toggle()<cr>",
    desc = "Toggle Repl",
  },
  {
    "<leader>ds",
    "<cmd>lua require'dap'.continue()<cr>",
    desc = "Start",
  },
  {
    "<leader>dq",
    "<cmd>lua require'dap'.close()<cr>",
    desc = "Quit",
  },
  {
    "<leader>dU",
    "<cmd>lua require'dapui'.toggle({reset = true})<cr>",
    desc = "Toggle UI",
  },
}

dap.adapters.python = {
  type = 'executable',
  command = 'python',
  args = { '-m', 'debugpy.adapter' },
}

dap.configurations.python = {
  {
    justMyCode = false,
    type = 'python',
    request = 'attach',
    name = 'Attach to Odoo Container',
    connect = {
      host = '127.0.0.1', -- Replace with container's IP if needed
      port = 5678,        -- Port exposed by the container for debugpy
    },
    pathMappings = {
      {
        localRoot = "/home/davit/naec/addons/hr/project_hr", -- Path to your local codebase
        remoteRoot = "/root/.local/share/Odoo/addons/11.0/project_hr", -- Path inside the container
      },
    },
  },
}

dapui.setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  layouts = {
    {
      elements = {
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40,
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25,
      position = "bottom",
    },
  },
  controls = {
    enabled = true,
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "□",
    },
  },
  floating = {
    max_height = nil,
    max_width = nil,
    border = "single",
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil,
    max_value_lines = 100,
  }
})

local mason_path = vim.fn.glob(vim.fn.stdpath "data" .. "/mason/")
pcall(function()
  require("dap-python").setup(mason_path .. "packages/debugpy/venv/bin/python")
end)

pcall(function()
  require("dap-python").test_runner = "pytest"
end)

require("nvim-dap-virtual-text").setup()

vim.fn.sign_define('DapBreakpoint', {text='🔴', texthl='DiagnosticSignError', linehl='', numhl=''})

dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end
