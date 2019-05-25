#!/bin/bash
set -eu -o pipefail
# download and install hasklig

hasklig_ver=1.1
name="Hasklig-${hasklig_ver}"
font_loc="$HOME/.fonts"
if [[ "$(uname -s)" =~ "Darwin" ]]; then
  font_loc="$HOME/Library/Fonts/"
fi

if [[ -f "$font_loc/Hasklig-Regular.otf" ]] ; then
  exit 0
fi

curl -L -O https://github.com/i-tu/Hasklig/releases/download/${hasklig_ver}/${name}.zip

unzip -d "$font_loc" "${name}.zip"
if command -v fc-cache &>/dev/null; then
  fc-cache
fi
rm "${name}.zip"
