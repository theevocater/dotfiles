#!/bin/bash
# symlink all my dotfiles

cd -P "$(dirname "$0")" || exit 1
cd ..

scripts/symlink_home \
  --base_src "." \
  --base_dest "$HOME/." \
  bash_logout \
  bash_profile \
  bashrc \
  gitconfig* \
  inputrc \
  tmux.conf \
  vim \
  vimrc \
  cvsignore \
  zshrc
