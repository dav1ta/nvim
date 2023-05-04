 require('neosolarized').setup({
    comment_italics = true,
    background_set = false,
  })
vim.cmd [[
try
  colorscheme neosolarized
  set termguicolors

    hi def IlluminatedWordText gui=None guibg=#363636
    hi def IlluminatedWordRead gui=None guibg=#363636
    hi def IlluminatedWordWrite gui=None guibg=#363636
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
