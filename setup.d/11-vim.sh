#!/bin/bash
set -eu -o pipefail
# build vim extensions with c bits
echo "Building vim submodules"

install_vim_plug() {
  echo "downloadingdownloading  vim-plug"
  mkdir -p rc.d/vim/autoload
  curl -fsSL https://raw.githubusercontent.com/junegunn/vim-plug/0.10.0/plug.vim
}

build_command_t() {
  echo "Building commant_t"
  pushd rc.d/vim/bundle/Command-T/ruby/command-t/ext/command-t/ || return
  ruby extconf.rb
  make
  popd || return
}

build_ycm() {
  echo "Building ycm"
  pushd rc.d/vim/bundle/YouCompleteMe/ || return
  python3 install.py \
    --clang-completer \
    --go-completer \
    --rust-completer \
    --java-completer
  popd || return
}

install_vim_plug
#build_command_t
#build_ycm
