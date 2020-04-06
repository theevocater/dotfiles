#!/bin/bash
set -eu -o pipefail
# Build a venv with some useful tools

cd -P "$(dirname "$0")" || exit 1
cd .. || exit 1
#echo "Building a python venv"

#if [[ -e venv ]]; then
  #rm -rf venv
#fi

#mkdir -p "$HOME/bin"

#virtualenv -p python3 venv
#venv/bin/pip install --requirement requirements.txt
scripts/symlink_home.py  \
  "venv/bin/" \
  "$HOME/bin/" \
  add-trailing-comma \
  ansible \
  ansible-config \
  ansible-connection \
  ansible-console \
  ansible-doc \
  ansible-galaxy \
  ansible-inventory \
  ansible-lint \
  ansible-playbook \
  ansible-pull \
  ansible-test \
  ansible-vault \
  autopep8 \
  aws \
  flake8 \
  isort \
  mypy \
  pip \
  pip-compile \
  python3 \
  reorder-python-imports \
  pre-commit \
  tox \
  virtualenv \
  wheel
