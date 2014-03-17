" Originally Written by Jake Kaufman with much help from Dannel Jurado and
" Jason Zaman

" Get rid of that stupid intro
set shortmess+=I

" loads our bundle directory
filetype off
" I have pathogen as a bundle so it needs to be added
runtime bundle/vim-pathogen/autoload/pathogen.vim
call pathogen#incubate()
call pathogen#helptags()

""""""""""""""""""""""""""""""""""""""""""""""""
" History
""""""""""""""""""""""""""""""""""""""""""""""""
set nocompatible
set history=1000

""""""""""""""""""""""""""""""""""""""""""""""""
" Interface
""""""""""""""""""""""""""""""""""""""""""""""""
set noerrorbells
set visualbell
set t_vb=""

set switchbuf=useopen,split

" Buffer handling
set hidden
" adds a ruler to the statusbar
set ruler
" sets the title of the xterm or what not to the filename
set title
" This allows better matching as it doesn't autochoose
set wildmenu
" shell style completion
set wildmode=list:longest,full
" Shows the current mode
set showmode
" Shows commands that match your incomplete typing
set showcmd
" Number our lines
set relativenumber
" always show the statusline
set laststatus=2
" redraw only when we need to.
set lazyredraw

set statusline=%F%m%r%h%w\ %{fugitive#statusline()}%=%{PasteMode()}[%l,%v][%p%%]

" Briefly jump the cursor to show the matching bracket
set showmatch
set matchtime=3
" Show the current working line
set cursorline

"set clipboard=unnamed,exclude:screen.*\\\\|xterm.*

""""""""""""""""""""""""""""""""""""""""""""""""
" Searching
""""""""""""""""""""""""""""""""""""""""""""""""
" Use normal regex's
nnoremap / /\v
vnoremap / /\v
" Assume case insensitive
set ignorecase
" Assume case sensitive in the case of uppercase chars
set smartcase
" Best match so far as you type
set incsearch
" Highlight the last search done
set hlsearch

""""""""""""""""""""""""""""""""""""""""""""""""
" Encoding
""""""""""""""""""""""""""""""""""""""""""""""""
set encoding=utf-8

""""""""""""""""""""""""""""""""""""""""""""""""
" Indenting/Spacing
""""""""""""""""""""""""""""""""""""""""""""""""
set tabstop=2
set softtabstop=2
set shiftwidth=2
set smarttab
set expandtab
set smartindent

""""""""""""""""""""""""""""""""""""""""""""""""
" Line Wrapping
""""""""""""""""""""""""""""""""""""""""""""""""
set wrap
set textwidth=79
set formatoptions=croql1n


""""""""""""""""""""""""""""""""""""""""""""""""
" Temp file storage
""""""""""""""""""""""""""""""""""""""""""""""""
if has("win32")
    set backupdir=$TEMP
    set directory=$TEMP
    let g:yankring_history_dir=$TEMP

    if version >= 703
        set undofile
        set undodir=$TEMP
    endif
else
    " enable backup files
    set backup
    silent execute '!mkdir -p $HOME/.vim/tmp/backup'
    set backupdir=~/.vim/tmp/backup/

    " swap files
    silent execute '!mkdir -p $HOME/.vim/tmp/swap'
    set directory=~/.vim/tmp/swap/

    " view files
    silent execute '!mkdir -p $HOME/.vim/tmp/views'
    set viewdir=~/.vim/tmp/views/

    " yankring
    silent execute '!mkdir -p $HOME/.vim/tmp/yankring'
    let g:yankring_history_dir = '~/.vim/tmp/yankring'

    if version >= 703
        set undofile
        silent execute '!mkdir -p $HOME/.vim/tmp/undo'
        set undodir=~/.vim/tmp/undo/ " undofiles
    endif
endif
" remember stuff when we close
" specifically marks, registers, searches and buffers
set viminfo='20,<50,s10,h,%

" Fix backspaces on broken systems
set backspace=indent,eol,start

""""""""""""""""""""""""""""""""""""""""""""""""
" Leader Hotkeys
""""""""""""""""""""""""""""""""""""""""""""""""
" sets our leader from \ to ,
let mapleader = " "

" set up to show spaces
set listchars=tab:>-,trail:_,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" sets ,n to silence search
nmap <silent> <leader>q :silent :nohlsearch<CR>

" add a toggle spelling key
nmap <silent> <leader>sp :set spell!<CR>

nmap <silent> <leader>p :set paste!<CR>

nmap <silent> <leader>n :set relativenumber!<CR> :GitGutterToggle<CR>

nmap <silent> <leader>r :RainbowToggle<CR>

nmap <silent> <leader>c :%s/\s\+$//<CR>

nmap <silent> <leader>ct :TlistToggle<CR>

nmap <silent> <leader>f :NERDTreeToggle<CR>
nmap <silent> <leader>F :NERDTreeFind<CR>

" fugitive keys
nmap <silent> <leader>gs :Gstatus<CR>
nmap <silent> <leader>W :Gw<CR>
nmap <silent> <leader>gd :Gdiff<CR>
nmap <leader>g :Git
nmap <leader>gc :Git checkout %

nmap <silent> <leader>pe :!p4 edit %<CR>

nnoremap <silent> <leader>y :YRShow<CR>

nnoremap <silent> <leader>u :GundoToggle<CR>

nnoremap <silent> <leader>m :w<CR> :make<CR> :cw<CR>

nnoremap <silent> <leader>ll :HighlightLongLines<CR>

inoremap {{ {<CR>}<Esc>ko

" spleling
"setlocal spell spelllang=en


""""""""""""""""""""""""""""""""""""""""""""""""
" Mappings
""""""""""""""""""""""""""""""""""""""""""""""""
" all the cool kids are doing it
noremap <Up> <nop>
noremap <Down> <nop>
noremap <Left> <nop>
noremap <Right> <nop>
" also kill home|end|pup|pdown
noremap <Home> <nop>
noremap <kHome> <nop>
noremap <End> <nop>
noremap <kEnd> <nop>
noremap <PageUp> <nop>
noremap <PageDown> <nop>


""""""""""""""""""""""""""""""""""""""""""""""""
" Syntax highlighting
""""""""""""""""""""""""""""""""""""""""""""""""
syntax on
filetype on
filetype plugin on
filetype indent on

" Sets the program to use for grep.
set grepprg=grep\ -nH\ $*

" * FileType formatting things

" for C-like programming, have automatic indentation:
autocmd FileType c,cpp,slang set cindent

" for actual C (not C++) programming where comments have explicit end
" characters, if starting a new line in the middle of a comment automatically
" insert the comment leader characters:
autocmd FileType c set formatoptions+=ro

" for CSS, also have things in braces indented:
autocmd FileType css set smartindent

" for HTML, generally format text, but if a long line has been created leave it
" alone when editing:
autocmd FileType html set formatoptions+=tl

" Makefiles don't want tabs -> spaces
autocmd FileType make set noexpandtab shiftwidth=8

" Json is just javascript
autocmd BufNewFile,BufRead *.json set ft=javascript

" Show column 90 only if not ro
autocmd BufEnter * setlocal colorcolumn=90
autocmd WinLeave * setlocal colorcolumn=0

" extends matching to if/else etc
runtime macros/matchit.vim

""""""""""""""""""""""""""""""""""""""""""""""""
" Folding
""""""""""""""""""""""""""""""""""""""""""""""""
set foldmethod=syntax
set foldlevel=99

""""""""""""""""""""""""""""""""""""""""""""""""
" Tlist stuff
""""""""""""""""""""""""""""""""""""""""""""""""
let Tlist_WinWidth = 40

""""""""""""""""""""""""""""""""""""""""""""""""
" VIM Tip: http://vim.wikia.com/wiki/Search_for_visually_selected_text
""""""""""""""""""""""""""""""""""""""""""""""""
" Search for selected text, forwards or backwards.
vnoremap <silent> * :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy/<C-R><C-R>=substitute(
  \escape(@", '/\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>
vnoremap <silent> # :<C-U>
  \let old_reg=getreg('"')<Bar>let old_regtype=getregtype('"')<CR>
  \gvy?<C-R><C-R>=substitute(
  \escape(@", '?\.*$^~['), '\_s\+', '\\_s\\+', 'g')<CR><CR>
  \gV:call setreg('"', old_reg, old_regtype)<CR>

""""""""""""""""""""""""""""""""""""""""""""""""
" comment cleanups
""""""""""""""""""""""""""""""""""""""""""""""""
" get rid of the default style of C comments, and define a style with two stars
" at the start of `middle' rows which (looks nicer and) avoids asterisks used
" for bullet lists being treated like C comments; then define a bullet list
" style for single stars (like already is for hyphens):
set comments-=s1:/*,mb:*,ex:*/
set comments+=s:/*,mb:\ *,ex:*/
set comments+=fb:\ *
" treat lines starting with a quote mark as comments (for 'Vim' files)
set comments+=b:\"

""""""""""""""""""""""""""""""""""""""""""""""""
" Dark background
""""""""""""""""""""""""""""""""""""""""""""""""
" I always work on dark terminals
set background=dark

" Make the completion menus readable
highlight Pmenu ctermfg=0 ctermbg=3
highlight PmenuSel ctermfg=0 ctermbg=7

""""""""""""""""""""""""""""""""""""""""""""""""
" Helper functions
""""""""""""""""""""""""""""""""""""""""""""""""
" Highlight lines longer than 80 characters as dark-red, lines longer than 90
" characters as a brighter red.
function! HighlightLongLines()
    if exists('b:highlight_long_lines') && b:highlight_long_lines == 1
        let b:highlight_long_lines = 0
        highlight OverLength NONE
        highlight SortaOverLength NONE
    else
        let b:highlight_long_lines = 1
        highlight OverLength ctermbg=124 guibg=#990000
        highlight SortaOverLength ctermbg=52 guibg=#330000
        match SortaOverLength /\m\%>80v.\%<92v/
        2match OverLength /\m\%>90v.\%<120v/
    endif
endfunction
command! HighlightLongLines call HighlightLongLines()

" simplify flipping between relative and absolute numbering
function! ToggleRelative()
    if (&relativenumber)
      set number
    else
      set relativenumber
    endif
endfunction
command! ToggleRelative call ToggleRelative()

" Toggle rainbow parens w/ the braces we want
function! RainbowToggle()
  RainbowParenthesesToggle
  RainbowParenthesesLoadBraces
endfunction
command! RainbowToggle call RainbowToggle()

function! PasteMode()
    if &paste
        return '(paste)'
    else
        return ''
    endif
endfunction

""""""""""""""""""""""""""""""""""""""""""""""""
" CommandT
""""""""""""""""""""""""""""""""""""""""""""""""
let g:CommandTMaxFiles = 2000000
let g:CommandTMaxDepth = 40
let g:CommandTMaxCachedDirectories = 0

let g:CommandTBackspaceMap=[ '<C-h>', '<BS>' ]
let g:CommandTCursorLeftMap='<Left>'

""""""""""""""""""""""""""""""""""""""""""""""""
" syntastic
""""""""""""""""""""""""""""""""""""""""""""""""
let g:syntastic_enable_signs = 1
let g:syntastic_auto_loc_list = 1

let g:syntastic_mode_map = { 'mode': 'passive',
                           \ 'active_filetypes': [],
                           \ 'passive_filetypes': [] }

set wildignore+=*.so,*.swp,*.zip,*.jar,*.pyc,*.class,*.bak

colorscheme tir_black
