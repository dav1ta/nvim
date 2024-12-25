local M = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
}

function M.config()
  local npairs = require("nvim-autopairs")
  npairs.setup({
    check_ts = true, -- Enable Treesitter integration for better pairing
    disable_filetype = { "TelescopePrompt", "vim" }, -- Disable for specific filetypes
  })

  local Rule = require("nvim-autopairs.rule")
  npairs.add_rules({
    -- Custom rule for Python triple quotes
    Rule('"""', '"""', "python")
      :with_pair(function(opts)
        local line = opts.line:sub(1, opts.col - 1)
        return line:match('"""') == nil -- Only complete if no existing triple quotes
      end),
  })
end

return M

