local parsers = {
  "c",
  "lua",
  "python",
  "bash",
  "diff",
  "dockerfile",
  "gitignore",
  "go",
  "tsx",
  "typescript",
  "html",
  "scss",
  "css",
  "javascript",
  "yaml",
}

local filetypes = {
  "c",
  "lua",
  "python",
  "sh",
  "bash",
  "diff",
  "dockerfile",
  "gitignore",
  "go",
  "typescriptreact",
  "typescript",
  "html",
  "scss",
  "css",
  "javascript",
  "yaml",
}

local function setup_textobjects()
  local ok, textobjects = pcall(require, "nvim-treesitter-textobjects")
  if not ok then
    return
  end

  textobjects.setup({
    select = {
      lookahead = true,
    },
    move = {
      set_jumps = true,
    },
  })

  local select = require("nvim-treesitter-textobjects.select")
  vim.keymap.set({ "x", "o" }, "af", function()
    select.select_textobject("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "if", function()
    select.select_textobject("@function.inner", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ac", function()
    select.select_textobject("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ic", function()
    select.select_textobject("@class.inner", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ap", function()
    select.select_textobject("@parameter.outer", "textobjects")
  end)
  vim.keymap.set({ "x", "o" }, "ip", function()
    select.select_textobject("@parameter.inner", "textobjects")
  end)

  local move = require("nvim-treesitter-textobjects.move")
  vim.keymap.set({ "n", "x", "o" }, "]m", function()
    move.goto_next_start("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]]", function()
    move.goto_next_start("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "]M", function()
    move.goto_next_end("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "][", function()
    move.goto_next_end("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[m", function()
    move.goto_previous_start("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[[", function()
    move.goto_previous_start("@class.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[M", function()
    move.goto_previous_end("@function.outer", "textobjects")
  end)
  vim.keymap.set({ "n", "x", "o" }, "[]", function()
    move.goto_previous_end("@class.outer", "textobjects")
  end)

  local swap = require("nvim-treesitter-textobjects.swap")
  vim.keymap.set("n", "<leader>.", function()
    swap.swap_next("@parameter.inner")
  end)
  vim.keymap.set("n", "<leader>,", function()
    swap.swap_previous("@parameter.inner")
  end)
end

local function setup()
  local ok, treesitter = pcall(require, "nvim-treesitter")
  if not ok then
    vim.notify("nvim-treesitter not found", vim.log.levels.ERROR)
    return
  end

  treesitter.setup()

  if type(treesitter.install) == "function" and vim.fn.executable("tree-sitter") == 1 then
    vim.schedule(function()
      pcall(function()
        treesitter.install(parsers)
      end)
    end)
  end

  local group = vim.api.nvim_create_augroup("user_treesitter", { clear = true })
  vim.api.nvim_create_autocmd("FileType", {
    group = group,
    pattern = filetypes,
    callback = function(args)
      local utils = require("user.utils")
      if utils.is_large_file(args.buf) then
        return
      end

      pcall(vim.treesitter.start, args.buf)
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
  })

  setup_textobjects()
end

return {
  setup = setup,
}
