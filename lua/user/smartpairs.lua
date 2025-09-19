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
