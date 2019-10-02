#!/bin/bash
set -eu -o pipefail
# install docker-ce

install_homebrew() {
  brew cask install docker
}

setup_apt() {
  sudo apt update
  sudo apt install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common

  curl -fsSL https://download.docker.com/linux/ubuntu/gpg > /tmp/docker.pub

  expected='9DC858229FC7DD38854AE2D88D81803C0EBFCD88'
  fingerprint=$(gpg --with-fingerprint --import-options show-only --import < /tmp/docker.pub | head -n2 | tail -n1 | tr -d ' ')

  if [[ "$expected" != "$fingerprint" ]] ; then
    echo "Warning fingerprint for docker key is wrong"
    exit 1
  fi

  sudo apt-key add /tmp/docker.pub

  sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable edge test"

  sudo apt update
  sudo apt install -y \
    docker-ce \
    docker-ce-cli \
    containerd.io

  sudo usermod -aG docker "${USER}"
}

if [[ "$(uname -s)" =~ "Darwin" ]]; then
  install_homebrew
elif [[ "$(lsb_release -s -i)" =~ "Ubuntu" ]]; then
  setup_apt
else
  echo "Unable to determine base OS. Not installing"
  return 1
fi
