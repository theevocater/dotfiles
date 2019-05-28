#!/bin/bash

# change to the directory the setup script exists in
cd -P "$(dirname "$0")" || exit 1

for i in setup.d/* ; do
  "$i"
done
