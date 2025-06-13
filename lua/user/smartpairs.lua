local M = {
  "m4xshen/hardtime.nvim",
  dependencies = { "MunifTanjim/nui.nvim" },
  event = "VeryLazy",
}

function M.config()
  require("hardtime").setup({
    -- your setup here
  })
end

return M  -- ✅ This must exist

