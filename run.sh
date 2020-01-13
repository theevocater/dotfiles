#!/bin/bash
set -eu -o pipefail

docker run -t -i \
  -v="$(pwd)":"$(pwd)" \
  dotfiles:latest /bin/bash \
