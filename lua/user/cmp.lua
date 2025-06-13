local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  vim.notify("cmp not found", vim.log.levels.ERROR)
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  vim.notify("luasnip not found", vim.log.levels.ERROR)
  return
end

local cmp_dap_status_ok, cmp_dap = pcall(require, "cmp_dap")
if not cmp_dap_status_ok then
  vim.notify("cmp_dap not found", vim.log.levels.ERROR)
  return
end

local compare = require("cmp.config.compare")

local function is_dap_buffer()
  return vim.api.nvim_buf_get_option(0, "buftype") == "prompt" and cmp_dap.is_dap_buffer()
end

local function check_backspace()
  local col = vim.fn.col(".") - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end

require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip/loaders/from_vscode").lazy_load { paths = "~/.config/nvim/.vsnip" }

local icons = require("user.icons")
local kind_icons = icons.kind

local function has_words_before()
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and not vim.api.nvim_buf_get_text(0, line - 1, col - 1, line - 1, col, {})[1]:match("^%s*$")
end

cmp.setup {
    enabled = function()
  if vim.b.large_buf then
    return false
  end
  return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or is_dap_buffer()
end,
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-k>"] = cmp.mapping.select_prev_item(),
    ["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping.scroll_docs(-1),
    ["<C-f>"] = cmp.mapping.scroll_docs(1),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping({
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    }),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif has_words_before() then
        cmp.complete()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  formatting = {
    fields = { "abbr", "kind", "menu" },
    format = function(entry, vim_item)
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind], vim_item.kind)
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
        dap = "[DAP]",
      })[entry.source.name]
      return vim_item
    end,
  },
  sources = cmp.config.sources({
    { name = "nvim_lsp" },

    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
    { name = "dap" },
  }),
  sorting = {
    priority_weight = 2,
   comparators =   {
   compare.offset,           -- 📌 Cursor prefix position = top
   compare.exact,            -- ✅ Exact match should win
   compare.score,            -- 🔍 Fuzzy match score
   compare.recently_used,    -- 🧠 Frequency matters
   compare.locality,         -- ✍️ Near cursor = better
   compare.kind,             -- 🔤 Function > variable, etc.
   compare.length,           -- 📏 Shorter = better
   compare.order,            -- 🧩 Default fallback
 },  },
}

