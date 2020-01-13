#!/bin/bash
set -eu -o pipefail

docker run -t -i \
  dotfiles:latest /bin/bash \
  #-v "$(pwd)/ansible":/root/ansible \
