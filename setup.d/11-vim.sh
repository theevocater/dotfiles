#!/bin/bash
set -eu -o pipefail
# build vim extensions with c bits

build_command_t() {
  pushd vim/bundle/Command-T/ruby/command-t/ext/command-t/ || return
  ruby extconf.rb
  make
  popd || return
}

build_ycm() {
  pushd vim/bundle/YouCompleteMe/ || return
  python3 install.py \
    --clang-completer \
    --go-completer \
    --rust-completer \
    --java-completer
  popd || return
}

build_command_t
build_ycm