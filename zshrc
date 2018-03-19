# Path to your oh-my-zsh installation.
export ZSH=$HOME/.dotfiles/oh-my-zsh

ZSH_THEME="agnoster"

plugins=(
  git
)

#fpath=(/usr/local/share/zsh-completions $fpath)

source $ZSH/oh-my-zsh.sh

alias work="cd projects/go/src/github.com/lyft/"
