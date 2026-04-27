require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
-- cmp and lsp load via lazy plugin specs
-- autopairs configured via lazy in user.smartpairs
-- nvim-tree and lualine load via lazy plugin configs
-- alpha and other UI plugins load via lazy plugin specs
require "user.autocommands"
-- lastplace, goto-preview, snippets, dap, navic configured via lazy plugin specs
require "user.winbar"

require "user.runner"
require "user.aitmux"
require "user.codereview"
--require "user.diffview"
-- require("user.cowboy").cowboy()
