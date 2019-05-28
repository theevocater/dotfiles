#!/bin/bash
set -eu -o pipefail

version=1.12.5
platform="$(uname | tr '[:upper:]' '[:lower:]')"
echo "Installing go $version $platform"

if [[ "$platform" == "linux" ]]; then
  curl -sSf -L -O "https://dl.google.com/go/go$version.$platform-amd64.tar.gz"
  echo "aea86e3c73495f205929cfebba0d63f1382c8ac59be081b6351681415f4063cf go$version.$platform-amd64.tar.gz" | sha256sum --quiet -c
  mkdir -p "$HOME/.jakeman"
  rm -rf "$HOME/.jakeman/go"
  tar -C "$HOME/.jakeman/" -xzf "go$version.$platform-amd64.tar.gz"
  rm "go$version.$platform-amd64.tar.gz"
elif [[ "$platform" == "darwin" ]]; then
  curl -sSf -L -O "https://dl.google.com/go/go$version.$platform-amd64.pkg"
  echo "2501498ad111f33a863ebd80eda0a34d2f6d62bb59fa20d523935e5c1732614f go$version.$platform-amd64.pkg" | sha256sum --quiet -c
  open "go$version.$platform-amd64.pkg"
  rm "go$version.$platform-amd64.pkg"
else
  exit 1
fi
