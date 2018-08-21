# Path to your oh-my-zsh installation.
MY_ZSH_ROOT=$HOME/.dotfiles/zsh
export ZSH=$MY_ZSH_ROOT/oh-my-zsh

ZSH_THEME="jakeman"

ZSH_CUSTOM=$MY_ZSH_ROOT/custom

DEFAULT_USER="$USER"

plugins=(
  brew
  go
  docker
  git
  helm
  kubectl
)

export GOPATH="$HOME/go"

#fpath=(/usr/local/share/zsh-completions $fpath)

alias dr='docker run --rm -t -i'

if [[ -d "$HOME/bin" ]] ; then
  export PATH="$HOME/bin:$PATH"
fi

if [[ -d "$HOME/go/bin" ]] ; then
  export PATH="$HOME/go/bin:$PATH"
fi

alias pyactive='source venv/bin/activate'

if [[ -d "$HOME/.cargo/bin" ]] ; then
  export PATH="$HOME/.cargo/bin:$PATH"
fi

source $ZSH/oh-my-zsh.sh
