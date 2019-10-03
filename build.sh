#!/bin/bash
set -eu -o pipefail

# build and tag dockerfile
#
sha="$(git rev-parse HEAD)-$(date +%s)"
docker build -t dotfiles:latest -t "dotfiles:$sha" .
