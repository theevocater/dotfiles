#!/bin/bash
set -eu -o pipefail
# symlink all my dotfiles

cd -P "$(dirname "$0")" || exit 1
cd .. || exit 1
echo "Symlinking Dotfiles"

scripts/symlink_home.py \
  "." \
  "$HOME/" \
  --prefix '.' \
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
