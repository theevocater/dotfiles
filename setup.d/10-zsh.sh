#!/bin/bash
set -eu -o pipefail

if ! command -v zsh &>/dev/null; then
  echo "Unable to switch to zsh: zsh is not installed"
  exit 1
fi
zsh_loc=$(command -v zsh)
if ! grep -q "${zsh_loc}" /etc/shells; then
  echo "${zsh_loc} is not in /etc/shells, adding"
  echo "${zsh_loc}" | sudo tee -a /etc/shells
fi
if [[ "$(uname -s)" =~ "Darwin" ]]; then
  cur_shell=$(dscl . -read "/Users/${USER}" UserShell | cut -d: -f2)
else
  cur_shell=$(getent passwd "${USER}" | cut -d: -f7)
fi
if [[ ! "${cur_shell}" =~ ${zsh_loc} ]]; then
  echo "Configuring zsh as shell"
  chsh -s "${zsh_loc}" "${USER}"
fi
