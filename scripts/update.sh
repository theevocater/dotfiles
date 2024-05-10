#!/bin/bash

OS=$(uname)
submodules() {
  echo "Updating git submodules to master"
  git submodule update --remote --merge
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
  if [[ "${OS}" != "Darwin" ]] ; then
    return 0
  fi
  echo "Dumping current moom preferences"

  defaults export com.manytricks.Moom plists/Moom.plist
}

lazy() {
  nvim --headless "+Lazy! update" +qa
}

omz() {
  "$ZSH"/tools/upgrade.sh
}

# TODO(jakeman) persist plists/Solarized Jake.terminal as well
#

submodules
python_packages
precommit
moom
lazy
omz
