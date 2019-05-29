#!/bin/bash
set -eu -o pipefail
# install rust
# TODO(jakeman) there has to be a better way

if command -v rustup &>/dev/null ; then
  exit 0
fi

echo "Installing rust"
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
