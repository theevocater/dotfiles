# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

# load solarized colors
# the \[\] pairs mark the characters as non-printing for the purposes of
# counting line length in bash.
if tput setaf 1 &> /dev/null; then
    tput sgr0
    if [[ $(tput colors) -ge 256 ]] 2>/dev/null; then
			#256 colors yea!
      BASE03="\[$(tput setaf 234)\]"
      BASE02="\[$(tput setaf 235)\]"
      BASE01="\[$(tput setaf 240)\]"
      BASE00="\[$(tput setaf 241)\]"
      BASE0="\[$(tput setaf 244)\]"
      BASE1="\[$(tput setaf 245)\]"
      BASE2="\[$(tput setaf 254)\]"
      BASE3="\[$(tput setaf 230)\]"
      YELLOW="\[$(tput setaf 136)\]"
      ORANGE="\[$(tput setaf 166)\]"
      RED="\[$(tput setaf 160)\]"
      MAGENTA="\[$(tput setaf 125)\]"
      VIOLET="\[$(tput setaf 61)\]"
      BLUE="\[$(tput setaf 33)\]"
      CYAN="\[$(tput setaf 37)\]"
      GREEN="\[$(tput setaf 64)\]"
    else
			# degrade to 8bit colors
      BASE03="\[$(tput setaf 8)\]"
      BASE02="\[$(tput setaf 0)\]"
      BASE01="\[$(tput setaf 10)\]"
      BASE00="\[$(tput setaf 11)\]"
      BASE0="\[$(tput setaf 12)\]"
      BASE1="\[$(tput setaf 14)\]"
      BASE2="\[$(tput setaf 7)\]"
      BASE3="\[$(tput setaf 15)\]"
      YELLOW="\[$(tput setaf 3)\]"
      ORANGE="\[$(tput setaf 9)\]"
      RED="\[$(tput setaf 1)\]"
      MAGENTA="\[$(tput setaf 5)\]"
      VIOLET="\[$(tput setaf 13)\]"
      BLUE="\[$(tput setaf 4)\]"
      CYAN="\[$(tput setaf 6)\]"
      GREEN="\[$(tput setaf 2)\]"
    fi
    BOLD="\[$(tput bold)\]"
    RESET="\[$(tput sgr0)\]"
else
    # Linux console colors. I don't have the energy
    # to figure out the Solarized values
    MAGENTA="\033[1;31m"
    ORANGE="\033[1;33m"
    GREEN="\033[1;32m"
    PURPLE="\033[1;35m"
    WHITE="\033[1;37m"
    BOLD=""
    RESET="\033[m"
fi

# load machines bashrc if necessary
if [[ -s /etc/bash/bashrc ]] ; then
    . /etc/bash/bashrc
fi

# load git completion
# we can depend on git-completion locally
if [[ -s $HOME/.dotfiles/git-completion.bash ]] ; then
    . $HOME/.dotfiles/git-completion.bash
fi
# load these separately because git-prompt was introduced with git-1.8
if [[ -s $HOME/.dotfiles/git-prompt.sh ]] ; then
    . $HOME/.dotfiles/git-prompt.sh
fi

if [[ -s ${HOME}/.profile ]] ; then
    . ${HOME}/.profile
fi

# load my inputrc so page up and stuff works
if [[ -s ~/.inputrc ]] ; then
    export INPUTRC="~/.inputrc"
fi

# pick up NPM
if [[ `type -t npm` && -d `npm bin` ]] ; then
    export PATH=$PATH:`npm bin`
    export PATH=$PATH:`npm bin -g 2>/dev/null`
fi

if [[ `type -t go` ]] ; then
    export GOPATH="$HOME/projects/go"
    export PATH=$PATH:$GOPATH/bin
fi

# load rvm and remind me to blow it up
if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
    source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
    export PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
    echo -ne "\033[1mPLEASE TYPE rvm implode!\n\033[0m"
fi

# try to pick up ruby
if [[ -s "/usr/local/share/chruby/chruby.sh" ]] ; then
  . /usr/local/share/chruby/chruby.sh
  export RUBIES=($HOME/.rubies/*)
  chruby 2.2.1
fi

if [[ -d "$HOME/local/bin/" ]] ; then
  export PATH=$HOME/local/bin:$PATH
fi

if [[ -d "$HOME/local/man/" ]] ; then
  export MANPATH=$HOME/local/bin:$MANPATH
fi

# pick up heroku if its around
if [[ -d "/usr/local/heroku/bin/" ]] ; then
  export PATH="/usr/local/heroku/bin:$PATH"
fi

# pick up love if its around
if [[ -d "/Applications/love.app/Contents/MacOS" ]] ; then
  export PATH="/Applications/love.app/Contents/MacOS:$PATH"
fi

if [[ `type -t brew` == "file" ]] ; then
    export PATH="/usr/local/bin:$PATH"
fi

os=`uname -s`

# exports
export EDITOR=`which vim`
export HISTCONTROL=ignoreboth:erasedups
export HISTFILE=~/.bash_history
export HISTFILESIZE=2000
export HISTIGNORE="&:ls:[bf]g:exit:history"
export HISTSIZE=2500
# prefer utf8
if [[ ${os} == "Linux" ]] ; then
    export LANG='en_US.utf8'
elif [[ ${os} == "Darwin" ]] ; then
    export LANG='en_US.UTF-8'
fi
export LESS="isR"

#aliases
alias df='df -h'
alias du='du -h'
alias indent='indent -kr -i8 -l72 -lc72'
alias irssi='TERM=screen irssi'
alias more="less" # never use more, use less instead
alias unhist='unset HISTFILE'
alias synergyc="killall synergyc; synergyc"
alias synergys="killall synergys; synergys"

# colorful commands
alias grep='grep --colour=auto'

# make ls print human readable sizes and append a character to identify items
lsopts=' -h -F '
if [[ ${os} == "Linux" ]] ; then
    lsopts+='--color=auto'
elif [[ ${os} == "Darwin" ]] ; then
    lsopts+='-G'
fi
alias ls="ls ${lsopts}"
unset lsopts

alias tree='tree -Csu'

# make all these commands safer
alias cp="cp -vi"
alias mv="mv -vi"
alias rm="rm -vi"

if [[ ${os} == "Linux" ]] ; then
    alias rmdir="rmdir -v"
fi

# make mkdir create long pathnames by default
alias mkdir="mkdir -p"

# shell options
# no bells
set bell-style none
# notifies about background jobs
set -o notify

# don't clobber files with >
set -o noclobber

# correct minor spelling errors in cd
shopt -s cdspell

# speeds up running commands
shopt -s checkhash

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
shopt -s checkwinsize

# save multiline commands on one line in the hist
shopt -s cmdhist

# Enable history appending instead of overwriting.
shopt -s histappend
# better history handling for failed commands
shopt -s histreedit histverify

# extended pattern matching for filename matching (aka globbing)
shopt -s extglob

# turn on ** (recursive) globbing
# specifically silence this one because its introduced in a later bash
shopt -s globstar &>/dev/null

# don't parse $PATH if i haven't typed anything
shopt -s no_empty_cmd_completion

function parse_git {
    if [[ $( type -t "__git_ps1" ) != "function" ]]
    then
        return
    fi
    branch=$(__git_ps1 "%s")
    if [[ -z $branch ]]; then
        return
    fi

    local forward="^"
    local behind="v"
    local dot="@"

    remote_pattern_ahead="Your branch is ahead of"
    remote_pattern_behind="Your branch is behind"
    remote_pattern_diverge="Your branch and (.*) have diverged"

    status="$(git status 2>/dev/null)"

    state=""
    if [[ $status =~ working.*clean ]]; then
        state=${GREEN}${dot}${RESET}
    else
        if [[ $status =~ "Untracked files" ]]; then
            state=${RED}${dot}${RESET}
        fi
        if [[ $status =~ "Changes not staged for commit" || $status =~ "Changed but not updated" ]]; then
            state=${state}${RED}${dot}${RESET}
        fi
        if [[ $status =~ "Changes to be committed" ]]; then
            state=${state}${YELLOW}${dot}${RESET}
        fi
    fi

    direction=""
    if [[ $status =~ $remote_pattern_ahead ]]; then
        direction=${GREEN}${forward}${RESET}
    elif [[ $status =~ $remote_pattern_behind ]]; then
        direction=${RED}${behind}${RESET}
    elif [[ $status =~ $remote_pattern_diverge ]]; then
        direction=${RED}${forward}${RESET}${GREEN}${behind}${RESET}
    fi

    branch=${BASE0}${branch}${RESET}
    git_bit="${BASE0}[${RESET}${branch}${state}\
${git_bit}${direction}${BASE0}]${RESET} "

    printf "%s" "$git_bit"
}

# if we have 256 colors use them in prompt
if [[ $TERM =~ '256color' ]]; then
    HOST_COLOR="\[\033[38;5;$((16 + $(cksum <<<$HOSTNAME | cut -f1 -d" ") % 216))m\]"
else
    HOST_COLOR="\[\033[0;$((31 + $(cksum <<<$HOSTNAME | cut -f1 -d" ") % 6))m\]"
fi

# shorten and colorize hostname for prompt
host=`hostname -s`
if [[ ${host} == "thirtytwo" ]]; then
  HOST_COLOR="${HOST_COLOR}32"
elif [[ ${host} =~ 'dev-' ]]; then
  HOST_COLOR="${HOST_COLOR}${host#dev-}"
else
  HOST_COLOR="${HOST_COLOR}${host:0:6}"
fi
unset host

if [[ $USER = 'jkaufman' || $USER = 'jdkaufma' ]]; then
    USER_COLOR="${GREEN}jk"
elif [[ $USER = 'jakeman' ]]; then
    USER_COLOR="${CYAN}jkmn"
elif [[ $EUID -eq 0 ]]; then
    USER_COLOR="${RED}r"
else
    USER_COLOR="${MAGENTA}${USER}"
fi

function set_prompt {
    git="$(parse_git)"
    PS1="${BASE00}\D{%H:%M:%S} ${USER_COLOR}${BASE1}@${HOST_COLOR}${BLUE} \w $git${BASE01}\$${RESET} "
    export PS1
}

# Change the window title of X terminals
case $TERM in
  aterm*|xterm*|rxvt*|Eterm)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
    ;;
  *)
    PROMPT_COMMAND='true'
    ;;
esac

export PROMPT_COMMAND="$PROMPT_COMMAND; set_prompt"

# moves the ssh socket to a symlink that is well defined so that when
# I reattach a tmux or screen session it will pick up the new socket
ssh_sock_symlink="/tmp/ssh-agent-$USER"
if [[ -n $SSH_AUTH_SOCK && $SSH_AUTH_SOCK != "$ssh_sock_symlink" ]]
then
  ln -sf "$SSH_AUTH_SOCK" "$ssh_sock_symlink"
  export SSH_AUTH_SOCK=$ssh_sock_symlink
fi

unset os
