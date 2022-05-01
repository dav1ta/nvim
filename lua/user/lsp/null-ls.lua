local null_ls_status_ok, null_ls = pcall(require, "null-ls")
if not null_ls_status_ok then
  return
end

null_ls.setup({
  debup = false,
  sources = {
    -- null_ls.builtins.formatting.black,
    -- null_ls.builtins.diagnostics.flake8,
    null_ls.builtins.formatting.shfmt.with({ filetypes = { "sh", "zsh" } }),
    null_ls.builtins.formatting.stylua,
    null_ls.builtins.formatting.prettier.with({
      filetypes = { "javascriptreact", "typescriptreact", "javascript", "typescript" },
    }),
  },
})
