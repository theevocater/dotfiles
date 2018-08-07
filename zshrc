# Path to your oh-my-zsh installation.
MY_ZSH_ROOT=$HOME/.dotfiles/zsh
export ZSH=$MY_ZSH_ROOT/oh-my-zsh

ZSH_THEME="jakeman"

ZSH_CUSTOM=$MY_ZSH_ROOT/custom

DEFAULT_USER="$USER"

plugins=(
  brew
  docker
  git
  helm
  kubectl
)

#fpath=(/usr/local/share/zsh-completions $fpath)

alias dr='docker run --rm -t -i'

if [[ -d "$HOME/bin" ]] ; then
  export PATH="$HOME/bin:$PATH"
fi

if [[ -d "$HOME/go/bin" ]] ; then
  export PATH="$HOME/go/bin:$PATH"
fi

source $ZSH/oh-my-zsh.sh
