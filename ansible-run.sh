#!/bin/bash
set -eu -o pipefail

# install ansible if necessary
if ! command -v  ansible ; then
  sudo scripts/bootstrap-ansible.sh
fi

ansible-playbook --verbose --inventory ansible/hosts --ask-become-pass ansible/root.yml
ansible-playbook --verbose --inventory ansible/hosts ansible/site.yml
