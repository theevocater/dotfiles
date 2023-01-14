#!/bin/bash
set -eu -o pipefail


bootstrap() {
  sync_submodules() {
    git submodule sync --recursive
    git submodule update --init --recursive
  }

  install_homebrew() {
    if ! command -v brew &>/dev/null; then
      /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    if [[ -d /opt/homebrew/bin ]] ; then
      eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
    brew upgrade
    brew install ansible
  }

  setup_apt() {
    apt update
    apt install -y ansible
  }

  sync_submodules

if ! command -v  ansible &>/dev/null ; then
  if [[ "$(uname -s)" =~ "Darwin" ]]; then
    install_homebrew
  elif [[ "$(lsb_release -s -i)" =~ "Ubuntu" ]]; then
    sudo sh -c setup_apt
  else
    echo "Unable to determine base OS. Not installing"
    return 1
  fi
fi
}

# install ansible if necessary
bootstrap

# Run playbooks that require root
ansible-playbook --verbose --inventory ansible/localhost --ask-become-pass ansible/root.yml

# Run playbooks that are for me
ansible-playbook --verbose --inventory ansible/localhost ansible/jakeman.yml
