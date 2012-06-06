# Test for an interactive shell.  There is no need to set anything
# past this point for scp and rcp, and it's important to refrain from
# outputting anything in those cases.
if [[ $- != *i* ]] ; then
    # Shell is non-interactive.  Be done now!
    return
fi

txtblk='\[\e[0;30m\]' # Black - Regular
txtred='\[\e[0;31m\]' # Red
txtgrn='\[\e[0;32m\]' # Green
txtylw='\[\e[0;33m\]' # Yellow
txtblu='\[\e[0;34m\]' # Blue
txtpur='\[\e[0;35m\]' # Purple
txtcyn='\[\e[0;36m\]' # Cyan
txtwht='\[\e[0;37m\]' # White
bldblk='\[\e[1;30m\]' # Black - Bold
bldred='\[\e[1;31m\]' # Red
bldgrn='\[\e[1;32m\]' # Green
bldylw='\[\e[1;33m\]' # Yellow
bldblu='\[\e[1;34m\]' # Blue
bldpur='\[\e[1;35m\]' # Purple
bldcyn='\[\e[1;36m\]' # Cyan
bldwht='\[\e[1;37m\]' # White
unkblk='\[\e[4;30m\]' # Black - Underline
undred='\[\e[4;31m\]' # Red
undgrn='\[\e[4;32m\]' # Green
undylw='\[\e[4;33m\]' # Yellow
undblu='\[\e[4;34m\]' # Blue
undpur='\[\e[4;35m\]' # Purple
undcyn='\[\e[4;36m\]' # Cyan
undwht='\[\e[4;37m\]' # White
bakblk='\[\e[40m\]'   # Black - Background
bakred='\[\e[41m\]'   # Red
badgrn='\[\e[42m\]'   # Green
bakylw='\[\e[43m\]'   # Yellow
bakblu='\[\e[44m\]'   # Blue
bakpur='\[\e[45m\]'   # Purple
bakcyn='\[\e[46m\]'   # Cyan
bakwht='\[\e[47m\]'   # White
txtrst='\[\e[0m\]'    # Text Reset

if [[ -f /etc/bash/bashrc ]] ; then
    . /etc/bash/bashrc
fi

if [[ -f /etc/profile.d/bash-completion.sh ]] ; then
    . /etc/profile.d/bash-completion.sh

# if we aren't on one of my gentoo boxes, we can depend on git-completion
# locally
elif [[ -f $HOME/.dotfiles/git-completion.bash ]] ; then
    . $HOME/.dotfiles/git-completion.bash
fi

if [[ -f ${HOME}/.profile ]] ; then
    . ${HOME}/.profile
fi

if [[ -f ~/.inputrc ]] ; then
    export INPUTRC="~/.inputrc"
fi

if [[ -s "$HOME/.rvm/scripts/rvm" ]] ; then
    source "$HOME/.rvm/scripts/rvm" # Load RVM into a shell session *as a function*
    PATH=$PATH:$HOME/.rvm/bin # Add RVM to PATH for scripting
fi

os=`uname -s`

export EDITOR=`which vim`
export HISTCONTROL=ignoreboth:erasedups
export HISTFILE=~/.bash_history
export HISTFILESIZE=2000
export HISTIGNORE="&:ls:[bf]g:exit:history"
export HISTSIZE=2500
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
alias wpa_supplicant='wpa_supplicant -Dwext -iwlan0 -c/etc/wpa_supplicant/wpa_supplicant.conf'

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

if [[ -e ${HOME}/scripts/Minecraft.sh ]] ; then
    alias minecraft="${HOME}/scripts/Minecraft.sh"
fi

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

#extended pattern matching for filename matching (aka globbing)
shopt -s extglob

#failed globs go to null
shopt -s nullglob

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

    remote_pattern_ahead="# Your branch is ahead of"
    remote_pattern_behind="# Your branch is behind"
    remote_pattern_diverge="# Your branch and (.*) have diverged"

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



if [[ $TERM =~ '256color' ]]; then
    host_color="\[\e[38;5;$((16 + $(cksum <<<$HOSTNAME | cut -f1 -d" ") % 216))m\]"
else
    host_color="\[\e[0;$((31 + $(cksum <<<$HOSTNAME | cut -f1 -d" ") % 6))m\]"
fi

if [[ $USER = 'jkaufman' || $USER = 'jdkaufma' ]]; then
    user_color=${txtgrn}
elif [[ $EUID -eq 0 ]]; then
    user_color=${txtred}
else
    user_color=${txtwht}
fi

function set_prompt {
    git="$(parse_git)"
    PS1="${user_color}\u${txtwht}@${host_color}\h${txtgrn} \w $git${bldblu}\$${txtrst} "
    export PS1
}

# Change the window title of X terminals 
case $TERM in
  aterm*|xterm*|rxvt*|Eterm)
    PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\007"'
    ;;  
#  screen*)
#    _TITLE='\[\e]0;\u@\h:\w\a\]'
##    PROMPT_COMMAND='echo -ne "\033k${USER}@${HOSTNAME%%.*}:${PWD/$HOME/~}\033\\"'
#    PROMPT_COMMAND='echo -ne "\033k$( ${1} )\034\\"'
#    unset _TITLE
#    ;;  
  # this isn't exactly a good idea, but this fixes a problem at work where
  # screen reports the terminal wrong.
  vt100)
    export TERM="screen-256color-bce"
    ;;
  *)
    PROMPT_COMMAND='true'
    ;;
esac

export PROMPT_COMMAND="$PROMPT_COMMAND; set_prompt"
