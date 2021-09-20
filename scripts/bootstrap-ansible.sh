#!/bin/bash
set -eu -o pipefail

install_homebrew() {
  if ! command -v brew &>/dev/null; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
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
  sudo sh -c setup_apt
else
  echo "Unable to determine base OS. Not installing"
  return 1
fi
