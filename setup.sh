#!/bin/bash
# originally borrowed from
# https://github.com/wyattanderson/dotfiles/blob/master/setup.sh

# change to the directory the setup script exists in
cd -P "$(dirname "$0")" || exit 1

update_git_completion() {
  # try to download the "correct" version of git completion
  git_version=$(git --version | cut -d" " -f3)

  # check if we have the right version of git completion stuffs
  if [[ -f git-completion.bash && -f git_completion_version && ${git_version} == $(cat git_completion_version) ]]; then
    echo "Git completion up to date for $git_version"
  else
    rm git_completion_version &>/dev/null
    echo "${git_version} > git_completion_version"
    echo "Downloading git completion script for $git_version"
    # here we fail (-f) quietly and save to same name as remote (-O)
    curl -f -L -O "https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-completion.bash"
    curl -f -L -O "https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-prompt.sh"
  fi
}

case $1 in
  gitc) # this is probably deprecated now that I use zsh
    update_git_completion
    ;;
  all | [yY])
    create_symlinks "$@"
    update_git_completion
    sync_submodules "$@"
    update_ssh "$@"
    # Install osx only things: fonts, brew, etc
    if [[ $(uname -s) =~ "Darwin" ]]; then
      install_homebrew
      install_hasklig
    fi
    set_zsh
    ;;
  *)
    echo "Wrong command"
    ;;
esac
