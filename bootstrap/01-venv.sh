#!/bin/bash
set -eu -o pipefail
# create venv for ansible
python3 -m venv /ansible/ansible_venv
# ubuntu python seems fucked idk
/ansible/ansible_venv/bin/pip install wheel
/ansible/ansible_venv/bin/pip install -r /root/bootstrap/requirements.txt
find /ansible/ansible_venv/bin/ -iname 'ansible*' -exec ln -s {} /usr/local/bin/ \;
