local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  vim.notify("lualine not found!", vim.log.levels.ERROR)
  return
end

local colors = {
  bg       = "#1e1e2e",
  fg       = "#cdd6f4",
  yellow   = "#f9e2af",
  cyan     = "#89dceb",
  darkblue = "#89b4fa",
  green    = "#a6e3a1",
  orange   = "#fab387",
  violet   = "#cba6f7",
  magenta  = "#f5c2e7",
  blue     = "#89b4fa",
  red      = "#f38ba8",
}

local mode_color = {
  n = colors.blue,
  i = colors.green,
  v = colors.magenta,
  [""] = colors.magenta,
  V = colors.magenta,
  c = colors.yellow,
  no = colors.red,
  s = colors.orange,
  S = colors.orange,
  [""] = colors.orange,
  ic = colors.yellow,
  R = colors.red,
  Rv = colors.red,
  cv = colors.red,
  ce = colors.red,
  r = colors.cyan,
  rm = colors.cyan,
  ["r?"] = colors.cyan,
  ["!"] = colors.cyan,
  t = colors.red,
}

local conditions = {
  hide_in_width = function()
    return vim.o.columns > 80
  end,
}

-- Define your components
local function mode()
  return {
    "mode",
    icon = "󰘳",
    color = function()
      return { fg = mode_color[vim.fn.mode()] or colors.blue, gui = "bold" }
    end,
  }
end

local function branch()
  return {
    "branch",
    icon = "",
    color = { fg = colors.violet },
  }
end

local function filename()
  return {
    "filename",
    path = 1,
    symbols = { modified = "  ", readonly = "  ", unnamed = "  " },
  }
end

local function diff()
  return {
    "diff",
    symbols = { added = " ", modified = " ", removed = " " },
    diff_color = {
      added    = { fg = colors.green },
      modified = { fg = colors.orange },
      removed  = { fg = colors.red },
    },
    cond = conditions.hide_in_width,
  }
end

local function diagnostics()
  return {
    "diagnostics",
    sources = { "nvim_diagnostic" },
    symbols = { error = " ", warn = " ", info = " ", hint = "󰌵 " },
    diagnostics_color = {
      error = { fg = colors.red },
      warn  = { fg = colors.yellow },
      info  = { fg = colors.blue },
      hint  = { fg = colors.cyan },
    },
  }
end

local function filetype()
  return {
    "filetype",
    icon_only = false,
    colored = true,
    icon = { align = "left" },
  }
end

local function location()
  return {
    "location",
    icon = "",
  }
end

local function progress()
  return {
    "progress",
    icon = "󰔟",
  }
end

local function spaces()
  return {
    function()
      return " " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
    end,
    cond = conditions.hide_in_width,
  }
end

-- SETUP
lualine.setup {
  options = {
    theme = "auto",
    globalstatus = true,
    icons_enabled = true,
    section_separators = { left = "", right = "" },
    component_separators = { left = "", right = "" },
    disabled_filetypes = { statusline = { "dashboard", "alpha" } },
  },
  sections = {
    lualine_a = { mode() },
    lualine_b = { branch(), diff() },
    lualine_c = { filename() },
    lualine_x = { diagnostics(), spaces(), filetype() },
    lualine_y = { location() },
    lualine_z = { progress() },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = { filename() },
    lualine_x = { location() },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}

