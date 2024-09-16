#!/bin/bash
set -eu -o pipefail

# Prep environment for running ansible.
# 1. sync submodules
# 2. potentially install ansible
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
    sudo apt update
    sudo apt install -y ansible
  }

  setup_dnf() {
    sudo dnf config-manager --enable crb
    sudo dnf install epel-release
    sudo dnf update
    sudo dnf install ansible
  }

  sync_submodules

  if ! command -v  ansible &>/dev/null ; then
    if [[ "$(uname -s)" =~ "Darwin" ]]; then
      install_homebrew
    elif grep -q "^Rocky Linux release 9.*$" /etc/redhat-release ; then
      setup_dnf
    elif [[ "$(lsb_release -s -i)" =~ "Ubuntu" ]]; then
      setup_apt
    else
      echo "Unable to determine base OS. Not installing"
      return 1
    fi
  fi
}

# install ansible if necessary
bootstrap

# Run playbooks that require root
ansible-playbook --verbose --ask-become-pass ansible/root.yml

# Run playbooks that are for me
ansible-playbook --verbose ansible/jakeman.yml
