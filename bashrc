# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

# colors
# Explanation:
# the \[\] pair ignores the characters inside of that block for the purspose of
# length in bash. this only works as part of the prompt
# \033 starts the color code. this should work on posix systems. (previously
# i used \e which is not)
txtblk='\[\033[0;30m\]' # Black - Regular
txtred='\[\033[0;31m\]' # Red
txtgrn='\[\033[0;32m\]' # Green
txtylw='\[\033[0;33m\]' # Yellow
txtblu='\[\033[0;34m\]' # Blue
txtpur='\[\033[0;35m\]' # Purple
txtcyn='\[\033[0;36m\]' # Cyan
txtwht='\[\033[0;37m\]' # White
bldblk='\[\033[1;30m\]' # Black - Bold
bldred='\[\033[1;31m\]' # Red
bldgrn='\[\033[1;32m\]' # Green
bldylw='\[\033[1;33m\]' # Yellow
bldblu='\[\033[1;34m\]' # Blue
bldpur='\[\033[1;35m\]' # Purple
bldcyn='\[\033[1;36m\]' # Cyan
bldwht='\[\033[1;37m\]' # White
unkblk='\[\033[4;30m\]' # Black - Underline
undred='\[\033[4;31m\]' # Red
undgrn='\[\033[4;32m\]' # Green
undylw='\[\033[4;33m\]' # Yellow
undblu='\[\033[4;34m\]' # Blue
undpur='\[\033[4;35m\]' # Purple
undcyn='\[\033[4;36m\]' # Cyan
undwht='\[\033[4;37m\]' # White
bakblk='\[\033[40m\]'   # Black - Background
bakred='\[\033[41m\]'   # Red
badgrn='\[\033[42m\]'   # Green
bakylw='\[\033[43m\]'   # Yellow
bakblu='\[\033[44m\]'   # Blue
bakpur='\[\033[45m\]'   # Purple
bakcyn='\[\033[46m\]'   # Cyan
bakwht='\[\033[47m\]'   # White
txtrst='\[\033[0m\]'    # Text Reset

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

if [[ -s "$HOME/local/bin/" ]] ; then
  export PATH=$HOME/local/bin:$PATH
fi

if [[ -s "$HOME/local/man/" ]] ; then
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
alias date="date +%a%t%b%t%D%l:%M:%S%p"
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
    if [[ $status =~ "working directory clean" ]]; then
        state=${bldgrn}${dot}${txtrst}
    else
        if [[ $status =~ "Untracked files" ]]; then
            state=${bldred}${dot}${txtrst}
        fi
        if [[ $status =~ "Changes not staged for commit" || $status =~ "Changed but not updated" ]]; then
            state=${state}${bldylw}${dot}${txtrst}
        fi
        if [[ $status =~ "Changes to be committed" ]]; then
            state=${state}${bldylw}${dot}${txtrst}
        fi
    fi

    direction=""
    if [[ $status =~ $remote_pattern_ahead ]]; then
        direction=${bldgrn}${forward}${txtrst}
    elif [[ $status =~ $remote_pattern_behind ]]; then
        direction=${bldred}${behind}${txtrst}
    elif [[ $status =~ $remote_pattern_diverge ]]; then
        direction=${bldred}${forward}${txtrst}${bldgrn}${behind}${txtrst}
    fi

    branch=${txtwht}${branch}${txtrst}
    git_bit="${bldred}[${txtrst}${branch}${state}\
${git_bit}${direction}${bldred}]${txtrst} "

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
    USER_COLOR="${txtgrn}jk"
elif [[ $USER = 'jakeman' ]]; then
    USER_COLOR="${txtcyn}jkmn"
elif [[ $EUID -eq 0 ]]; then
    USER_COLOR="${txtred}r"
else
    USER_COLOR="${undpur}${USER}"
fi

function set_prompt {
    git="$(parse_git)"
    PS1="${bldblk}\D{%H:%M:%S} ${USER_COLOR}${txtwht}@${HOST_COLOR}${txtgrn} \w $git${bldblu}\$${txtrst} "
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
