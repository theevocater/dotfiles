#!/bin/bash
# originally borrowed from
# https://github.com/wyattanderson/dotfiles/blob/master/setup.sh

# change to the directory the setup script exists in
cd -P "$(dirname "$0")" || exit -1

prompt() {
  if [[ $2 =~ ^[yY]$ ]]; then
    return 0
  fi
  read -r -p "$1 y[n] " -n 1
  echo
  # if the answer isn't yes, skip
  if [[ -z ${REPLY} || ${REPLY} =~ ^[^Yy]$ ]]; then
    return 1
  fi
  return 0
}

create_symlinks() {
  # Iterate over the list of setup files we want to alias from our dotfile
  # distribution
  for file in bash_logout bash_profile bashrc gitconfig* inputrc tmux.conf vim vimrc cvsignore zshrc; do
    # If the file exists, ask the user if they'd like us to move it to
    # FILENAME_old. Otherwise, overwrite.
    if [[ -e $HOME/.${file} ]]; then
      if ! prompt "$HOME/.${file} exists, overwrite?" "$1"; then
        echo "Skipping ${file}"
        continue
      fi
    fi
    # Add the appropriate symlink
    echo "Overwritting ~/.${file}"
    ln -svnf "${PWD}/${file}" "$HOME/.${file}"
  done
}

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

sync_submodules() {
  if prompt "Sync submodules?" "$1"; then
    ./sync-sb.sh
  fi
}

update_ssh() {
  if prompt "Copy authorized_users?" "$1"; then
    cp -v authorized_keys "$HOME/.ssh/"
  fi

  if [[ ! (-s $HOME/.ssh/config) ]]; then
    if prompt "Copy default ssh config?" "$1"; then
      cp -v default_ssh_config "$HOME/.ssh/config"
    fi
  fi
}

hasklig_ver=1.1
install_hasklig() {
  name="Hasklig-${hasklig_ver}"
  curl -L -O https://github.com/i-tu/Hasklig/releases/download/${hasklig_ver}/${name}.zip
  font_loc="$HOME/.fonts"
  if [[ "$(uname -s)" =~ "Darwin" ]]; then
    font_loc="$HOME/Library/Fonts/"
  fi
  unzip -d "$font_loc" "${name}.zip"
  if which fc-cache &>/dev/null; then
    fc-cache
  fi
  rm "${name}.zip"
}

install_homebrew() {
  if ! brew --version &>/dev/null; then
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  fi
  brew install reattach-to-user-namespace tmux htop vim zsh
  brew upgrade
}

build_command_t() {
  pushd vim/bundle/Command-T/ruby/command-t/ext/command-t/ || return
  ruby extconf.rb
  make
  popd || return
}

set_zsh() {
  if ! which zsh &>/dev/null; then
    echo "zsh is not installed"
    exit -1
  fi
  zsh_loc=$(which zsh)
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
    chsh -s "${zsh_loc}" "${USER}"
  fi
}

setup_yum() {
  sudo yum update
  sudo yum install -y \
    ShellCheck \
    ctags \
    docker \
    glide \
    golang \
    kernel-devel \
    python3 \
    python3-virtualenv \
    redhat-rpm-config \
    ruby \
    ruby-devel \
    vim \
    zsh
  sudo systemctl enable docker
  sudo systemctl start docker
}

case $1 in
  symlinks)
    create_symlinks "$@"
    ;;
  git)
    git config --local user.name "Jake Kaufman"
    git config --local user.email "theevocater@gmail.com"
    ;;
  gitc) # this is probably deprecated now that I use zsh
    update_git_completion
    ;;
  sb)
    sync_submodules "$@"
    build_command_t
    ;;
  ct)
    build_command_t
    ;;
  ssh)
    update_ssh "$@"
    ;;
  font)
    install_hasklig
    ;;
  zsh)
    set_zsh
    ;;
  brew)
    install_homebrew
    ;;
  yum)
    setup_yum
    ;;
  all | [yY])
    create_symlinks "$@"
    update_git_completion
    sync_submodules "$@"
    update_ssh "$@"
    # Install osx only things: fonts, brew, etc
    if [[ $(uname -s) =~ "Darwin" ]]; then
      brew
      install_hasklig
    fi
    set_zsh
    ;;
  *)
    echo "Wrong command"
    ;;
esac
