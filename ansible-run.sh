#!/bin/bash
set -eu -o pipefail

# install ansible if necessary
if ! command -v  ansible ; then
  sudo scripts/bootstrap-ansible.sh
fi

# Run playbooks that require root
ansible-playbook --verbose --inventory ansible/hosts --ask-become-pass ansible/root.yml

# Run playbooks that are for me
ansible-playbook --verbose --inventory ansible/hosts ansible/jakeman.yml
