#!/bin/bash
# originally borrowed from
# https://github.com/wyattanderson/dotfiles/blob/master/setup.sh

# change to the directory the setup script exists in
cd -P "$( dirname "$0" )"

prompt () {
  if [[ $2 =~ ^[yY]$ ]] ; then
    return 0
  fi
  read -p "$1 y[n] " -n 1
  echo
  # if the answer isn't yes, skip
  if [[ -z ${REPLY} || ${REPLY} =~ ^[^Yy]$ ]] ; then
    return 1
  fi
  return 0
}

create_symlinks () {
  # Iterate over the list of setup files we want to alias from our dotfile
  # distribution
  for file in bash_logout bash_profile bashrc gitconfig* gvimrc inputrc tmux.conf vim vimrc cvsignore
  do
    # If the file exists, ask the user if they'd like us to move it to
    # FILENAME_old. Otherwise, overwrite.
    if [[ -e ~/.${file} ]] ; then
      prompt "~/.${file} exists, overwrite?" $1
      if [[ $? -ne 0 ]] ; then
        echo "Skipping ${file}"
        continue
      fi
    fi
    # Add the appropriate symlink
    echo "Overwritting ~/.${file}"
    if [[ "$TERM" =~ 256 && -f "${PWD}/256${file}" ]] ; then
      ln -svnf "${PWD}/256${file}" ~/.${file}
    else
      ln -svnf ${PWD}/${file} ~/.${file}
    fi
  done
}

update_git_completion () {
  # try to download the "correct" version of git completion
  git_version=`git --version | cut -d" " -f3`

  # check if we have the right version of git completion stuffs
  if [[ -f git-completion.bash \
    && -f git_completion_version \
    && $git_version == `cat git_completion_version` ]] ; then
    echo "Git completion up to date for $git_version"
  else
    rm git_completion_version &>/dev/null
    echo $git_version > git_completion_version
    echo "Downloading git completion script for $git_version"
    # here we fail (-f) quietly and save to same name as remote (-O)
    curl -f -L -O https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-completion.bash
    curl -f -L -O https://raw.githubusercontent.com/git/git/v$git_version/contrib/completion/git-prompt.sh
  fi
}

sync_submodules () {
  prompt "Sync submodules?" $1
  if [[ $? -eq 0 ]] ; then
    ./sync-sb.sh
  fi
}

update_ssh () {
  prompt "Copy authorized_users?" $1
  if [[ $? -eq 0 ]] ; then
    cp -v authorized_keys $HOME/.ssh/
  fi

  if [[ !(-s $HOME/.ssh/config) ]] ; then
    prompt "Copy default ssh config?" $1
    if [[ $? -eq 0 ]] ; then
      cp -v default_ssh_config $HOME/.ssh/config
    fi
  fi
}

case $1 in
  symlinks)
    create_symlinks
    ;;
  git)
    update_git_completion
    ;;
  sb)
    sync_submodules
    ;;
  ssh)
    update_ssh
    ;;
  "" | [yY])
    create_symlinks $1
    update_git_completion $1
    sync_submodules $1
    update_ssh $1
    ;;
  *)
    ;;
esac

