#!/bin/bash
set -eu -o pipefail
# Set up ansible prereqs
apt update
apt install -y \
  python3 \
  python3-dev \
  python3-apt \
  python3-venv
