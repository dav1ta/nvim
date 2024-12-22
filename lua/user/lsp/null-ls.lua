local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  vim.notify("null-ls not found", vim.log.levels.ERROR)
  return
end

local formatting = null_ls.builtins.formatting
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup {
  debug = false,
  sources = {
    formatting.prettier.with({
      filetypes = { "javascript", "typescript", "json", "yaml", "markdown" },
      extra_args = { "--print-width", "100" },
    }),
    formatting.black.with { extra_args = { "--fast" } },
    formatting.stylua,
 --diagnostics.flake8.with { extra_args = { "--max-line-length", "88" } },
  },

  on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local opts = { noremap = true, silent = true }

    buf_set_keymap("n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

    vim.cmd [[
      command! Flake8Enable lua require("null-ls").enable({ require("null-ls").builtins.diagnostics.flake8 })
      command! Flake8Disable lua require("null-ls").disable({ require("null-ls").builtins.diagnostics.flake8 })
    ]]
  end,
}

local unwrap = {
  method = null_ls.methods.DIAGNOSTICS,
  filetypes = { "rust" },
  generator = {
    fn = function(params)
      local diagnostics = {}
      for i, line in ipairs(params.content) do
        local col, end_col = line:find("unwrap()")
        if col and end_col then
          table.insert(diagnostics, {
            row = i,
            col = col,
            end_col = end_col,
            source = "unwrap",
            message = string.format("Hey %s, consider handling this unwrap!", os.getenv("USER")),
            severity = 2, -- Warning level
          })
        end
      end
      return diagnostics
    end,
  },
}

null_ls.register(unwrap)

