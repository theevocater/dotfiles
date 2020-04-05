#!/bin/bash
set -eu -o pipefail

ansible-playbook -v -i ansible/hosts "ansible/jkaufman/$1"
