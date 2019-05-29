#!/bin/bash
set -eu -o pipefail
# Set up necessary packages for me to function

install_homebrew() {
  if ! command -v brew &>/dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  brew upgrade
  brew install \
    htop \
    python \
    reattach-to-user-namespace \
    tmux \
    vim \
    zsh
}

setup_apt() {
  sudo apt update
  sudo apt install -y \
    build-essential \
    cmake \
    ctags \
    curl \
    git \
    python3-dev \
    python3-pip \
    python3-venv \
    ruby-dev \
    shellcheck \
    tmux \
    vim-nox \
    xclip \
    zsh
}

setup_fedora() {
  sudo yum update
  sudo yum install -y \
    ShellCheck \
    ctags \
    docker \
    glide \
    kernel-devel \
    python3 \
    python3-virtualenv \
    redhat-rpm-config \
    ruby \
    ruby-devel \
    vim \
    zsh
  sudo systemctl enable docker
  sudo systemctl start docker
}

if [[ "$(uname -s)" =~ "Darwin" ]]; then
  install_homebrew
elif [[ "$(lsb_release -s -i)" =~ "Ubuntu" ]]; then
  setup_apt
elif [[ "$(lsb_release -s -i)" =~ "Fedora" ]]; then
  setup_fedora
else
  echo "Unable to determine base OS. Not installing"
  return 1
fi
