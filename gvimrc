"set guifont=Envy\ Code\ R\ 10

" these only work in 256 colors
" autocmd FileType c,cpp,slang RainbowParenthesesLoadBraces
" autocmd FileType c,cpp,slang RainbowParenthesesToggle
nnoremap <leader>R :RainbowParenthesesToggle<CR>

set guioptions-=T
set guioptions-=r
set guioptions-=l
set guioptions-=L
set guioptions-=b
set guioptions-=t
set guioptions-=m
set guioptions+=e

set background=dark
colorscheme ir_black
