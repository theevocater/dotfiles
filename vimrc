" Originally Written by Jake Kaufman with much help from Dannel Jurado and
" Jason Zaman

" Get rid of that stupid intro
set shortmess+=I

" loads our bundle directory
call pathogen#runtime_append_all_bundles()
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

set switchbuf=useopen,split

"set statusline+=%{fugitive#statusline()}
set statusline=%F%m%r%h%w\ %{fugitive#statusline()}%=[%l,%v][%p%%]

" Buffer handling
set hidden
set ruler
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
set number
" always show the laststatus
set laststatus=2
" Briefly jump the cursor to show the matching bracket
set showmatch
set matchtime=3

set clipboard=unnamed,exclude:screen.*\\\\|xterm.*

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
set tabstop=4
set softtabstop=4
set shiftwidth=4
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
    " backup files
    "silent execute '!mkdir -p $HOME/.vim/tmp/backup'
    set backupdir=~/.vim/tmp

    "swap files
    "silent execute '!mkdir -p $HOME/.vim/tmp/swap'
    set directory=~/.vim/tmp
    "silent execute '!mkdir -p $HOME/.vim/tmp/yankring'
    let g:yankring_history_dir = '$HOME/.vim/tmp/yankring'

    if version >= 703
        set undofile
        "silent execute '!mkdir -p $HOME/.vim/tmp/undo'
        set undodir=~/.vim/tmp/undo// " undofiles
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
let mapleader = ","

" set up to show spaces
set listchars=tab:>-,trail:?,eol:$
nmap <silent> <leader>s :set nolist!<CR>

" sets ,n to silence search
nmap <silent> <leader>q :silent :nohlsearch<CR>

" add a toggle spelling key
nmap <silent> <leader>sp :set spell!<CR>

nmap <silent> <leader>p :set paste!<CR>
nmap <silent> <leader>n :set number!<CR>

nmap <silent> <leader>c :%s/\s\+$//<CR>

nmap <silent> <leader>t :TlistToggle<CR>

nmap <silent> <leader>f :NERDTreeToggle<CR>

nmap <silent> <leader>e :!p4 edit %<CR>

nnoremap <silent> <leader>y :YRShow<CR>

nnoremap <silent> <leader>g :GundoToggle<CR>

nnoremap <silent> <leader>m :w<CR> :make<CR> :cw<CR>

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
"autocmd FileType c,cpp,slang set spell!

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
let Tlist_Ctags_Cmd = "/home/user/jkaufman/local/bin/ctags"
let Tlist_WinWidth = 40

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

colorscheme tir_black
