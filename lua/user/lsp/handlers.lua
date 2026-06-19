local M = {}

M.capabilities = vim.lsp.protocol.make_client_capabilities()

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if status_cmp_ok then
  M.capabilities.textDocument.completion.completionItem.snippetSupport = true
  M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)
end

M.setup = function()
  local d = require("user.icons").diagnostics
  vim.diagnostic.config({
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = d.Error,
        [vim.diagnostic.severity.WARN] = d.Warning,
        [vim.diagnostic.severity.HINT] = d.Hint,
        [vim.diagnostic.severity.INFO] = d.Information,
      },
    },
    virtual_lines = false,
    virtual_text = {
      severity = { min = vim.diagnostic.severity.WARN },
    },
    update_in_insert = true,
    underline = false,
    severity_sort = true,
    float = {
      focusable = true,
      style = "minimal",
      border = "rounded",
      source = "if_many",
      header = "",
      prefix = "",
    },
  })
end


local function attach_navic(client, bufnr)
  vim.g.navic_silence = true
  local status_ok, navic = pcall(require, "nvim-navic")
  if not status_ok then
    return
  end

  local utils = require("user.utils")
  if not utils.is_large_file(bufnr) then
    navic.attach(client, bufnr)
  end
end

local function lsp_keymaps(bufnr)
  local opts = { buffer = bufnr, silent = true }
  vim.keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)
  vim.keymap.set("n", "gD", "<cmd>Telescope lsp_declarations<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
  vim.keymap.set("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
  vim.keymap.set("n", "gr", "<cmd>Telescope lsp_references<CR>", opts)
  vim.keymap.set("n", "gl", function()
    vim.diagnostic.open_float()
  end, opts)
  vim.keymap.set("n", "gs", function()
    vim.lsp.buf.signature_help({ border = "rounded" })
  end, opts)
  vim.keymap.set("n", "<M-f>", "<cmd>Format<cr>", opts)
  vim.keymap.set("n", "ga", function()
    vim.lsp.buf.code_action()
  end, opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<M-s>", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>ca", "<cmd>lua vim.lsp.buf.code_action()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>f", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "[d", '<cmd>lua vim.diagnostic.goto_prev({ border = "rounded" })<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "]d", '<cmd>lua vim.diagnostic.goto_next({ border = "rounded" })<CR>', opts)
  -- vim.api.nvim_buf_set_keymap(bufnr, "n", "<leader>q", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

M.on_attach = function(client, bufnr)
  lsp_keymaps(bufnr)
  attach_navic(client, bufnr)

  -- Enable built-in inlay hints on 0.11+
  if vim.lsp.inlay_hint then
    pcall(vim.lsp.inlay_hint.enable, bufnr, true)
  end
end


function M.remove_augroup(name)
  if vim.fn.exists("#" .. name) == 1 then
    vim.cmd("au! " .. name)
  end
end

-- Format command now provided by Conform (:Format); avoid duplicate

return M
