-- NvimAutopairs quick cues:
-- 1. Type `(` in insert mode → plugin inserts `()` and keeps the cursor centered.
-- 2. Type `"` or `'` → automatic closing quote saves a keystroke.
-- 3. `<M-e>` while inside text → trigger FastWrap to surround selections quickly.
-- 4. `<BS>` on an empty pair → deletes both sides without leaving strays.
-- 5. Confirm a completion with `<CR>` → autopairs adds matching brackets automatically.
-- 6. `:lua require('nvim-autopairs').toggle()` → disable/enable when editing templates.
-- 7. Adjust `disable_filetype` below if a picker needs raw input.

local M = {
  "windwp/nvim-autopairs",
  event = "InsertEnter",
}

function M.config()
  local ok, npairs = pcall(require, "nvim-autopairs")
  if not ok then return end

  npairs.setup({
    check_ts = true,
    fast_wrap = {},
    disable_filetype = { "TelescopePrompt", "vim" },
  })

  local cmp_ok, cmp = pcall(require, "cmp")
  if cmp_ok then
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end
end

return M
