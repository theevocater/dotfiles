#!/bin/bash
# originally borrowed from
# https://github.com/wyattanderson/dotfiles/blob/master/setup.sh

cd -P "$( dirname "$0" )"

prompt () {
  read -p "$1" -n 1
  echo
  # if the answer isn't yes, skip
  if [[ -z $REPLY || $REPLY =~ ^[^Yy]$ ]]
  then
    return 1
  fi
  return 0
}

# Iterate over the list of setup files we want to alias from our dotfile
# distribution
for file in bash_logout bash_profile bashrc gitconfig gvimrc inputrc tmux.conf screenrc vim vimrc cvsignore
do
  # If the file exists, ask the user if they'd like us to move it to
  # FILENAME_old. Otherwise, overwrite.
  if [[ -e ~/.${file} ]] ; then
    prompt "~/.$file exists, overwrite? y[n] "
    if [[ $? -ne 0 ]]
    then
      continue
    fi
  fi
  # Add the appropriate symlink
  echo "ln -svnf ${PWD}/${file} ~/.${file}"
done

if [[ !(-f git-completion.bash) ]]
then
  echo "Downloading git completion script"
  curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash > git-completion.bash
  curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > git-prompt.sh
else
  prompt "Update completion? y[n] "
  if [[ $? -eq 0 ]]
  then
    curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash > git-completion.bash
    curl https://raw.github.com/git/git/master/contrib/completion/git-prompt.sh > git-prompt.sh
  fi
fi

prompt "Sync submodules? y[n] "
if [[ $? -eq 0 ]]
then
  ./sync-sb.sh
fi
