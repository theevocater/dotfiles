#!/bin/bash
set -eu -o pipefail
# Set up ansible prereqs

apt update
apt install -y ansible
