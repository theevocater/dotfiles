#!/bin/bash
set -eu -o pipefail

git submodule sync --recursive
git submodule update --init --recursive
