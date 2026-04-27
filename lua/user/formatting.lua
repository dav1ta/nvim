-- Conform quick cues:
-- 1. `:Format` → run the async formatter defined below for the current buffer.
-- 2. `:lua require('conform').format({ async = false })` → force sync formatting.
-- 3. `:ConformInfo` → inspect which formatters are available/configured.
-- 4. Map `vim.lsp.buf.format()` as fallback when external tools are missing.
-- 5. Extend `formatters_by_ft` to register project-specific formatter combos.
-- 6. Toggle `format_on_save` if you switch to an auto-format workflow.
-- 7. Watch `notify_on_error` to catch formatter failures right away.

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
    require("conform").format({ async = true, lsp_format = "fallback" })
  end, { desc = "Format file" })
end

return M
