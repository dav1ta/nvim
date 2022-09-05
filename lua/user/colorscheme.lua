vim.cmd [[
try
  colorscheme dracula 
  set termguicolors
  " hi Visual  guifg=#000000 guibg=#FFFFFF gui=none
  "  hi DiagnosticUnderlineError guifg=#000000 ctermfg=131 guibg=#fa967d ctermbg=234 cterm=bold gui=bold
  "  hi DiagnosticUnderlineWarn guifg=#000000 ctermfg=131 guibg=#fa967d ctermbg=234 cterm=bold gui=bold
  "  hi DiagnosticUnderlineInfo guifg=#000000 ctermfg=131 guibg=#fa967d ctermbg=234 cterm=bold gui=bold
  "  hi DiagnosticUnderlineHint guifg=#000000 ctermfg=131 guibg=#fa967d ctermbg=234 cterm=bold gui=bold
  "
catch /^Vim\%((\a\+)\)\=:E185/
  colorscheme default
  set background=dark
endtry
]]
