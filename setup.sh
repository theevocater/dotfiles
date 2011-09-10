#!/bin/bash

pwd="$( cd -P "$( dirname "$0" )" && pwd )"

ln -vsnf ${pwd}/bash_logout ${HOME}/.bash_logout
ln -vsnf ${pwd}/bash_profile ${HOME}/.bash_profile
ln -vsnf ${pwd}/bashrc ${HOME}/.bashrc
ln -vsnf ${pwd}/gitconfig ${HOME}/.gitconfig
ln -vsnf ${pwd}/gvimrc ${HOME}/.gvimrc
ln -vsnf ${pwd}/inputrc ${HOME}/.inputrc
ln -vsnf ${pwd}/screenrc ${HOME}/.screenrc
ln -vsnf ${pwd}/vim/ ${HOME}/.vim
ln -vsnf ${pwd}/vimrc ${HOME}/.vimrc
