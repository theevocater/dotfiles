#!/bin/bash
set -eu -x -o pipefail

cd -P "$(dirname "$0")" || exit 1
cd .. || exit 1

# try to download the correct version of git completion
git_version=$(git --version | cut -d" " -f3)

# check if we have the right version of git completion stuffs
if [[ -f git-completion.bash && -f git_completion_version && ${git_version} == $(cat git_completion_version) ]]; then
  exit 0
fi

rm -f git_completion_version &>/dev/null
echo "${git_version}" > git_completion_version
echo "Downloading git completion script for $git_version"
# here we fail (-f) quietly and save to same name as remote (-O)
curl -sSf -L -O "https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-completion.bash"
curl -sSf -L -O "https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-prompt.sh"
