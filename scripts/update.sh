#!/bin/bash

OS=$(uname)
submodules() {
  echo "Updating git submodules to master"
  git submodule update --remote --merge

  fix_ycmd
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

fix_ycmd() {
  pushd rc.d/vim/pack/github/start/YouCompleteMe/ || exit
  # ycmd always leaves a mess of go stuff on update
  go clean

  # fix submodules after
  git submodule foreach --recursive git clean -fxxd
  popd || exit
}

# TODO(jakeman) persist plists/Solarized Jake.terminal as well
#

submodules
python_packages
precommit
moom
