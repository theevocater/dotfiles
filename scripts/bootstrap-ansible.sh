#!/bin/bash
set -eu -o pipefail

# Set up ansible
if [[ $EUID -ne 0 ]] ; then
  echo "Please run as root"
  exit 1
fi

install_homebrew() {
  if ! command -v brew &>/dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  brew upgrade
  brew install ansible
}

setup_apt() {
  apt update
  apt install -y ansible
}

if [[ "$(uname -s)" =~ "Darwin" ]]; then
  install_homebrew
elif [[ "$(lsb_release -s -i)" =~ "Ubuntu" ]]; then
  setup_apt
else
  echo "Unable to determine base OS. Not installing"
  return 1
fi
