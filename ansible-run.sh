#!/bin/bash
set -e

ansible-playbook -i ansible/hosts ansible/site.yml -v -K
