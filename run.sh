#!/bin/bash
set -eu -o pipefail

docker run -t -i \
  -v "$(pwd)/ansible":/root/ansible \
  -w /root/ansible \
  dotfiles:latest /bin/bash
