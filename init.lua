require "user.options"
require "user.keymaps"
require "user.plugins"
require "user.colorscheme"
--require "user.cmp"
require "user.lsp"
--require "user.telescope"
-- require "user.treesitter"
-- require "user.autopairs"
-- require "user.gitsigns"
require "user.nvim-tree"
require "user.lualine"
require "user.toggleterm"
require "user.project"
require "user.impatient"
-- require "user.indentline"
require "user.alpha"
-- require "user.whichkey"
require "user.autocommands"
require "user.stabilize"
require "user.lastplace"
require "user.preview"
-- require "user.trouble"
-- require "user.neogen"
require "user.todo-comments"
-- require "user.quickscope"
-- require "user.matchup"
--require "user.numb"
-- require "user.lsp_signature"
require "user.comment"
-- require "user.surround"
require "user.outline"
require "user.snippets"
require "user.dap"
require "user.navic"
require "user.winbar"
-- require "user.illuminate"
-- require "user.colorizer"



function run_makefile(args)
  local Terminal = require('toggleterm.terminal').Terminal
  local Project = require('project_nvim.project')
  local project_root = Project.get_project_root(vim.fn.expand('%:p'))
  if project_root == nil then
    vim.cmd("echohl Error | echo 'Could not find project root' | echohl None")
    return
  end
  local makefile_path = project_root .. '/Makefile'
  if vim.fn.filereadable(makefile_path) ~= 1 then
    makefile_path = project_root .. '/makefile'
  end
  if vim.fn.filereadable(makefile_path) ~= 1 then
    vim.cmd("echohl Error | echo 'Could not find Makefile in project root' | echohl None")
    return
  end
  local make_cmd = "make -f " .. makefile_path
  if args ~= nil and args ~= '' then
    make_cmd = make_cmd .. ' ' .. args
  end
  Terminal:new({
    cmd = make_cmd,
    cwd = project_root,
    direction = "horizontal",
    size = 40,
    close_on_exit = false,
  }):toggle()
end

vim.cmd("command! -nargs=* RunMakefile lua run_makefile(<q-args>)")

