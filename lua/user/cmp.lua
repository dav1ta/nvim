local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then
  print("cmp not found")
  return
end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then
  print("luasnip not found")
  return
end

local cmp_dap_status_ok, cmp_dap = pcall(require, "cmp_dap")
if not cmp_dap_status_ok then
  print("cmp_dap not found")
  return
end

local compare = require "cmp.config.compare"

  enabled = function()
    return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt" or cmp_dap.is_dap_buffer()
  end,


require("luasnip/loaders/from_vscode").lazy_load()
require("luasnip/loaders/from_vscode").lazy_load { paths = "~/.config/nvim/.vsnip" }
local check_backspace = function()
  local col = vim.fn.col "." - 1
  return col == 0 or vim.fn.getline("."):sub(col, col):match "%s"
end

--   פּ ﯟ   some other good icons
local icons = require "user.icons"

local kind_icons = icons.kind
-- find more here: https://www.nerdfonts.com/cheat-sheet

local has_words_before = function()
  if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
end


cmp.setup {
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body) -- For `luasnip` users.
    end,
  },
  mapping = {
    ["<C-k>"] = cmp.mapping.select_prev_item(),
		["<C-j>"] = cmp.mapping.select_next_item(),
    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
    ["<C-y>"] = cmp.config.disable, -- Specify `cmp.config.disable` if you want to remove the default `<C-y>` mapping.
    ["<C-e>"] = cmp.mapping {
      i = cmp.mapping.abort(),
      c = cmp.mapping.close(),
    },
    -- Accept currently selected item. If none selected, `select` first item.
    -- Set `select` to `false` to only confirm explicitly selected items.
    ["<C-h>"] = cmp.mapping.confirm { select = true },
    ["<Right>"] = cmp.mapping.confirm { select = true },
    ["<CR>"] = cmp.mapping.confirm ({ select = false,
      behavior = cmp.ConfirmBehavior.Replace}),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif has_words_before() then
        cmp.complete()
      elseif luasnip.expandable() then
        luasnip.expand()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      elseif check_backspace() then
        fallback()
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
         -- cmp.select_prev_item()
         local is_insert_mode = function()
            return vim.api.nvim_get_mode().mode:sub(1, 1) == "i"
          end
          if is_insert_mode() then -- prevent overwriting brackets
            confirm_opts.behavior = ConfirmBehavior.Insert
          end
          local entry = cmp.get_selected_entry()
          local is_copilot = entry and entry.source.name == "copilot"
          if is_copilot then
            confirm_opts.behavior = ConfirmBehavior.Insert
            confirm_opts.select = true
          end
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {
      "i",
      "s",
    }),
  },
  formatting = {
    fields = {"abbr", "kind","menu" },
    format = function(entry, vim_item)
      -- Kind icons
      vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind],vim_item.kind)
      -- vim_item.kind = string.format('%s %s', kind_icons[vim_item.kind], vim_item.kind) -- This concatonates the icons with the name of the item kind
      vim_item.menu = ({
        nvim_lsp = "[LSP]",
        luasnip = "[Snippet]",
        buffer = "[Buffer]",
        path = "[Path]",
        dap = "[DAP]",
        --['vim-dadbod-completion'] = '[DB]',

      })[entry.source.name]
      return vim_item
    end,
  },
  sources = {
-- {
--       name = "copilot",
--       -- keyword_length = 0,
--       max_item_count = 2,
--       trigger_characters = {
--         {
--           "?",
--         }
--       },
--       group_index = 2,
--     },
    { name = "nvim_lsp",group_index=2},
    { name = "buffer" ,group_index=2},
    { name = "path" ,group_index=2},
    { name = "luasnip",group_index=2},
    { name = "dap" ,group_index=2},

  },

sorting = {
    priority_weight = 2,
    comparators = {
        compare.score,
        compare.offset,
        compare.exact,
        compare.recently_used,
        compare.sort_text,
        compare.locality,
    },
  },
  formatters = {
    insert_text = require("copilot_cmp.format").remove_existing
  },

  -- confirm_opts = {
  --   behavior = cmp.ConfirmBehavior.Replace,
  --   select = false,
  -- },
}

