# vim:ft=zsh
#
# jakeman's Theme for zsh
# Inspired by agnoster and powerline and solarized
#
#
FIRST_SEGMENT='FALSE'

segmentize() {
  local bg fg command
  bg="%K{$1}"
  fg="%F{$2}"
  command="$3"
  if [[ $FIRST_SEGMENT != 'FALSE' ]] ; then
    echo -n "%{%b%K{default}%F{default}%}|"
	fi
	echo -n "%{$bg$fg%} $command "
  FIRST_SEGMENT='TRUE'
}

p_end() {
  echo -n '==%{%b%K{default}%F{black}%}>%{%f%b%k%} '
}

p_dir() {
  segmentize default grey '%~'
}

p_status() {
  local line
  line=()
  if [[ $RETVAL -ne 0 ]] ; then
    line+="%{%F{red}%}✖︎ $RETVAL"
  fi
  if [[ -n "$line" ]] ; then
    segmentize black black "$line"
  fi
}

p_time() {
  segmentize default grey "%D{%H:%M:%S}"
}

p_git() {
  if $(git rev-parse --is-inside-work-tree &>/dev/null); then
		setopt promptsubst
		autoload -Uz vcs_info

		zstyle ':vcs_info:*' get-revision true
		zstyle ':vcs_info:*' check-for-changes true
		zstyle ':vcs_info:*' stagedstr '✚'
		zstyle ':vcs_info:*' unstagedstr '●'
		zstyle ':vcs_info:*' formats '%b %u%c'
		zstyle ':vcs_info:*' actionformats '%a %u%c'
		vcs_info
		segmentize default black "${vcs_info_msg_0_}"
	fi
}

p_venv() {
  if [[ -n ${VIRTUAL_ENV} ]] ; then
    segmentize default magenta ${VIRTUAL_ENV:t:gs/%/%%}
  fi
}

prompt() {
  RETVAL=$?
  p_status
  p_time
  p_dir
  p_venv
	p_git
  p_end
}

PROMPT='%{%f%b%k%}$(prompt)'
