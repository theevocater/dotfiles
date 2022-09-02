#!/bin/bash

OS=$(uname)
submodules() {
  echo "Updating git submodules to master"
  git submodule foreach git pull origin master

  omz update
}

python_packages() {
  echo "Updating requirements.txt"
  pip-compile --upgrade --annotate --verbose --header
}

precommit() {
  echo "updating pre-commit hooks"
  pre-commit autoupdate
}

moom() {
  if [[ "$OS" != "Darwin" ]] ; then
    return 0
  fi
  echo "Dumping current moom preferences"
  scripts/moom-save.sh plists/Moom.plist
}

# TODO(jakeman) persist plists/Solarized Jake.terminal as well
#u

submodules
python_packages
precommit
moom
