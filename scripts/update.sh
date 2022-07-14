#!/bin/bash

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
  echo "epdating pre-commit hooks"
  pre-commit autoupdate
}

moom() {
  echo "Dumping current moom preferences"
  scripts/moom-save.sh plists/Moom.plist
}

# TODO(jakeman) persist plists/Solarized Jake.terminal as well

submodules
python_packages
precommit
moom
