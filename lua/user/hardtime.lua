local M = {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "BufReadPre",
}

function M.config()
  require("hardtime").setup({
    max_count = 5, -- How many bad keypresses before warning
    disable_mouse = true, -- Allow mouse usage
    hint = true, -- Show hint after bad behavior
    notification = true, -- Use notifications
    restricted_keys = {
      ["h"] = { "n", "x" },
      ["j"] = { "n", "x" },
      ["k"] = { "n", "x" },
      ["l"] = { "n", "x" },
    },
    disabled_keys = {
      ["<Up>"] = {}, -- Allow Up key
      ["<Down>"] = {}, -- Allow Down key
    },
    restriction_mode = "hint", -- Show hint instead of blocking
    max_time = 5000, -- Max allowed time between bad keypresses (ms)
    allow_different_key = true, -- Allow using different keys without reset
    resetting_keys = {}, -- No extra resetting keys
    restricted_keys_patterns = {}, -- No regex patterns
    enable_visual = false, -- Visual mode punishment disabled
    disable_hardtime = false, -- Plugin enabled by default
    disabled_filetypes = { "qf", "netrw", "NvimTree", "lazy", "mason" }, -- Don't trigger inside these
  })
end

return M

