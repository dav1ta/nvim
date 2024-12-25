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



hi def TelescopePromptPrefix guifg=#ff79c6 guibg=#44475a
hi def TelescopeNormal guibg=#282a36
hi def TelescopePreviewTitle guifg=#282a36 guibg=#50fa7b
hi def TelescopePromptTitle guifg=#282a36 guibg=#ff5555
hi def TelescopeSelection guibg=#44475a guifg=#f8f8f2
hi def TelescopeResultsDiffAdd guifg=#50fa7b
hi def TelescopeResultsDiffChange guifg=#f1fa8c
hi def TelescopeResultsDiffDelete guifg=#ff5555
hi def TelescopeMatching guibg=#6272a4 guifg=#8be9fd

hi def TelescopeBorder guifg=#44475a guibg=#44475a
hi def TelescopePromptBorder guifg=#44475a guibg=#44475a
hi def TelescopePromptNormal guifg=#f8f8f2 guibg=#44475a
hi def TelescopeResultsTitle guifg=#282a36 guibg=#50fa7b

hi def TelescopePromptBottom guifg=#f8f8f2 guibg=#44475a
hi def TelescopePromptBottom guibg=#44475a guifg=#f8f8f2

catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]


