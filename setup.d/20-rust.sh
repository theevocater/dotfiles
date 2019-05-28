#!/bin/bash
set -eu -o pipefail
# install rust
# TODO(jakeman) there has to be a better way
echo "Installing rust"

curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
