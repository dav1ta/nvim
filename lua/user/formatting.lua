local M = {}

function M.setup()
  local ok, conform = pcall(require, "conform")
  if not ok then
    return
  end

  conform.setup({
    notify_on_error = true,
    formatters_by_ft = {
      lua = { "stylua" },
      javascript = { "prettier" },
      typescript = { "prettier" },
      javascriptreact = { "prettier" },
      typescriptreact = { "prettier" },
      json = { "prettier" },
      yaml = { "prettier" },
      markdown = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      html = { "prettier" },
      python = { "black" },
      go = { "gofmt" },
      rust = { "rustfmt" },
    },
    -- Disable format on save per user preference; use :Format manually
    format_on_save = false,
  })

  -- Create :Format command to use conform
  vim.api.nvim_create_user_command("Format", function()
    require("conform").format({ async = true, lsp_fallback = true })
  end, { desc = "Format file" })
end

return M
