" Disable python2
let g:loaded_python_provider = 0

" Always use global venv for neovim
let g:python3_host_prog="~/.dotfiles/venv/bin/python3"

set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vimrc
