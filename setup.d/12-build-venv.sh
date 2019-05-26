#!/bin/bash
# Build a venv with some useful tools

cd -P "$(dirname "$0")" || exit 1
cd ..

if [[ -e venv ]]; then
  rm -rf venv
fi

python3 -m venv venv
venv/bin/pip install --requirement requirements.txt
scripts/symlink_home  \
  --base_src "venv/bin/" \
  --base_dest "$HOME/bin/" \
  black \
  flake8 \
  isort \
  mypy \
  pre-commit
