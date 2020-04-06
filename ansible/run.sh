#!/bin/bash
set -e

ansible-playbook -i hosts site.yml -v -K
