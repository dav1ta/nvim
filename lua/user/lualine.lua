local status_ok, lualine = pcall(require, "lualine")
if not status_ok then
  return
end


local hide_in_width = function()
  return vim.fn.winwidth(0) > 80
end

local icons = require "user.icons"

local diagnostics = {
  "diagnostics",
  sources = { "nvim_diagnostic" },
  sections = { "error", "warn","hint" },
  symbols = { error = icons.diagnostics.Error .. " ", warn = icons.diagnostics.Warning .. " " },
  colored = false,
  update_in_insert = false,
  always_visible = true,
}

local diff = {
  symbols = { added = " ", modified = " ", removed = " " },
  "diff",
  colored = true,
  cond = hide_in_width,
}

local mode = {
  "mode",
  fmt = function(str)
    return "-- " .. str .. " --"
  end,
}

local filetype = {
  "filetype",
  icons_enabled = false,
  icon = nil,
}

local branch = {
  "branch",
  icons_enabled = true,
  icon = "",
}

local location = {
  "location",
  padding = 0,
}



-- cool function for progress
local progress = function()
  local current_line = vim.fn.line "."
  local total_lines = vim.fn.line "$"
  local chars = {  "██","▇▇","▆▆", "▅▅", "▄▄", "▃▃", "▂▂", "▁▁","__" }
  local line_ratio = current_line / total_lines
  local index = math.ceil(line_ratio * #chars)
  return chars[index]
end

local spaces = function()
  return "spaces: " .. vim.api.nvim_buf_get_option(0, "shiftwidth")
end

-- local nvim_gps = function()
--   local gps_location = gps.get_location()
--   if gps_location == "error" then
--     return ""
--   else
--     return gps.get_location()
--   end
-- end

-- TODO: find out what is overriding this
vim.opt.laststatus = 3

lualine.setup {
  options = {
    icons_enabled = true,
    theme = "auto",
    component_separators = { left = "", right = "" },
    section_separators = { left = "", right = "" },
    -- disabled_filetypes = { "alpha", "dashboard", "NvimTree", "Outline", "toggleterm" },
    disabled_filetypes = { "alpha", "dashboard", "toggleterm" },
    always_divide_middle = true,
  },
  sections = {
    -- lualine_a = { branch, diagnostics },
    lualine_a = { branch, },
    lualine_b = { diagnostics,diff,{'filename',file_status=true,path=1}},
    -- lualine_c = { _gps },
    lualine_c = {
      -- { nvim_gps, cond = hide_in_width },
    },
    -- lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_x = { progress , "encoding", filetype },
    lualine_y = { location },
    lualine_z = { },
  },
  inactive_sections = {
    lualine_a = {},
    lualine_b = {},
    lualine_c = {},
    lualine_x = { "location" },
    lualine_y = {},
    lualine_z = {},
  },
  tabline = {},
  extensions = {},
}

vim.opt.laststatus = 3
