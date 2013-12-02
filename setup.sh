#!/bin/bash
# originally borrowed from
# https://github.com/wyattanderson/dotfiles/blob/master/setup.sh

# change to the directory the setup script exists in
cd -P "$( dirname "$0" )"

prompt () {
  read -p "$1 y[n] " -n 1
  echo
  # if the answer isn't yes, skip
  if [[ -z $REPLY || $REPLY =~ ^[^Yy]$ ]]
  then
    return 1
  fi
  return 0
}

download_git () {
  # try to download the "correct" version of git completion
  git_version=`git --version | cut -d" " -f3`

  echo "Downloading git completion script for $git_version"
  # here we fail (-f) quietly and save to same name as remote (-O)
  curl -f -O https://raw.github.com/git/git/v$git_version/contrib/completion/git-completion.bash
  curl -f -O https://raw.github.com/git/git/v$git_version/contrib/completion/git-prompt.sh
}

# Iterate over the list of setup files we want to alias from our dotfile
# distribution
for file in bash_logout bash_profile bashrc gitconfig gvimrc inputrc tmux.conf screenrc vim vimrc cvsignore
do
  # If the file exists, ask the user if they'd like us to move it to
  # FILENAME_old. Otherwise, overwrite.
  if [[ -e ~/.${file} ]] ; then
    prompt "~/.$file exists, overwrite?"
    if [[ $? -ne 0 ]]
    then
      continue
    fi
  fi
  # Add the appropriate symlink
  if [[ "$TERM" =~ 256 && -f "${PWD}/256${file}" ]]
  then
    ln -svnf "${PWD}/256${file}" ~/.${file}
  else
    ln -svnf ${PWD}/${file} ~/.${file}
  fi
done

if [[ !(-s git-completion.bash) || !(-s git-prompt.sh) ]]
then
  download_git
else
  prompt "Update completion?"
  if [[ $? -eq 0 ]]
  then
    download_git
  fi
fi

prompt "Sync submodules?"
if [[ $? -eq 0 ]]
then
  ./sync-sb.sh
fi

prompt "Copy authorized_users?"
if [[ $? -eq 0 ]]
then
  cp authorized_keys ../.ssh/
fi
