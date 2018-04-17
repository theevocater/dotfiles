# Path to your oh-my-zsh installation.
MY_ZSH_ROOT=$HOME/.dotfiles/zsh
export ZSH=$MY_ZSH_ROOT/oh-my-zsh

ZSH_THEME="agnoster"

ZSH_CUSTOM=$MY_ZSH_ROOT/custom

DEFAULT_USER="$USER"

plugins=(
  brew
  docker
  git
)

#fpath=(/usr/local/share/zsh-completions $fpath)

source $ZSH/oh-my-zsh.sh
