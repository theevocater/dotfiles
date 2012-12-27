#!/bin/bash
# originally borrowed from
# https://github.com/wyattanderson/dotfiles/blob/master/setup.sh

cd -P "$( dirname "$0" )"

# Iterate over the list of setup files we want to alias from our dotfile
# distribution
for file in bash_logout bash_profile bashrc gitconfig gvimrc inputrc tmux.conf screenrc vim vimrc cvsignore
do
  # If the file exists, ask the user if they'd like us to move it to
  # FILENAME_old. Otherwise, overwrite.
  if [[ -e ~/.${file} ]] ; then
    read -p "~/.$file exists, overwrite? y[n] " -n 1
    echo
    # if the answer isn't yes, skip
    if [[ -z $REPLY || $REPLY =~ ^[^Yy]$ ]] ; then
      continue
    fi
  fi
  # Add the appropriate symlink
  ln -svnf ${PWD}/${file} ~/.${file}
done

echo "Downloading git completion script"
if [[ !(-f git-completion.bash) ]]
then
  curl https://raw.github.com/git/git/master/contrib/completion/git-completion.bash > git-completion.bash
fi

echo "Syncing submodules"
./sync-sb.sh
