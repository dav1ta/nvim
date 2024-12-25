local M = {
  "Exafunction/codeium.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp",
  },
}

function M.config()
  local codeium = require("codeium")
  codeium.setup({
    -- Add any specific configurations here
  })
end

return M
