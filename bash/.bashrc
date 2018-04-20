# If not running interactively, don't do anything
[ -z "$PS1" ] && return

#####
#
# Functions
#
#####

# Generate a random password:
#   $1 = number of characters; defaults to 32
#   $2 = include special characters; 1 = yes, 0 = no; defaults to 1
randpass() {
  [ "$2" == "0" ] && CHAR="[:alnum:]" || CHAR="[:graph:]"
  cat /dev/urandom | tr -cd "$CHAR" | head -c ${1:-32}
  echo
}

# Generate ssh-fingerprints given a key file:
#   $1 = key file
fingerprints() {
  local file="$1"
  while read l; do
    [[ -n $l && ${l###} = $l ]] && ssh-keygen -l -f /dev/stdin <<<$l
  done < $file
}

# Make sure ssh uses the right socket
ssh_agent_setup() {
  # If we are comming from ssh and are forwarding an agent
  # then move on
  if [ "${SSH_TTY}" ] && [ "${SSH_AUTH_SOCK}" ]; then
    # do nothing
    return
  else
    unset SSH_AUTH_SOCK
    if [ -e "${HOME}/.gnupg/S.gpg-agent.ssh" ]; then
      SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
    else
      SSH_AUTH_SOCK="/var/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"
    fi
    export SSH_AUTH_SOCK
  fi
}

# Look at my default knobs
if [ -f "${HOME}/.bashrc_vars" ]; then
  . "${HOME}/.bashrc_vars"
fi

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE bash(1)
HISTSIZE=6000
PROMPT_COMMAND="history -a"

export HISTFILESIZE PROMPT_COMMAND

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# Set other preferences
export PAGER="less -s -M +Gg"

# Color for manpages
export LESS_TERMCAP_mb=$'\e[1;31m'           # begin bold
export LESS_TERMCAP_md=$'\e[1;38;5;208m'     # begin blink
export LESS_TERMCAP_so=$'\e[01;44;37m'       # begin reverse video
export LESS_TERMCAP_us=$'\e[01;38;5;111m'    # begin underline
export LESS_TERMCAP_me=$'\e[0m'              # reset bold/blink
export LESS_TERMCAP_se=$'\e[0m'              # reset reverse video
export LESS_TERMCAP_ue=$'\e[0m'              # reset underline

# Aliases
alias ll="ls -lah"
alias tmux="tmux -2"
alias diff="diff -u"

# Save my sanity from long dirs
if [[ -d "$HOME/symlinks" ]]; then
  export CDPATH=${HOME}/symlinks
fi

# Make 'w' column for user longer
export PROCPS_USERLEN=24

# set PATH so it includes user's private bin if it exists
if [[ -d "$HOME/bin" ]]; then
  PATH="$HOME/bin:$PATH"
fi

# Get os platform
os_platform=$(uname -s)

# POSIX substring parameter expansion
if [ "$TERM" != "256color" ]; then
  # Enable colors for ls, etc.  Prefer ~/.dir_colors #64489
  if type -P dircolors >/dev/null ; then
    if [[ -f ~/.dir_colors ]]; then
      eval $(dircolors -b ~/.dir_colors)
    elif [[ -f /etc/DIR_COLORS ]]; then
      eval $(dircolors -b /etc/DIR_COLORS)
    else
      eval $(dircolors)
    fi
  else
    if [[ -f ~/.bsd_dir_colors ]]; then
      export LSCOLORS=$(cat ~/.bsd_dir_colors)
    fi
  fi

  if [[ ${EUID} == 0 ]]; then
    PS1='\[\033[01;31m\]\h\[\033[01;37m\] \W \$\[\033[00m\] '
  else
    PS1='\[\033[01;36m\]\u@\h\[\033[01;37m\] \W \$\[\033[00m\] '
  fi

  if [ ${os_platform} == "FreeBSD" ] || [ ${os_platform} == "Darwin"  ];then
    alias ls='ls -G'
  else
    alias ls='ls --color=auto'
  fi

  alias grep='grep --colour=auto'
else
  # show root@ when we don't have colors
  PS1='\u@\h \W \$ '
fi

# Platform specifics
if [ ${os_platform} == "Darwin"  ];then
  # Disable saving sessions in OSX
  touch "$HOME/.bash_sessions_disable"
fi

# AWS CLI bash stuff
if [ -f "$HOME/.bash_aws" ]; then
  source "$HOME/.bash_aws"
fi

# Disable stopping flowcontrol
stty -ixon

# gpg-agent stuff
if [ ${ENABLE_GPG:-1} -eq 0 ]; then
  # Is daemon running?
  if ! pgrep -x -u "${USER}" gpg-agent > /dev/null 2>&1; then
    eval $(gpg-agent --daemon)
  fi
  # gpg pinentry
  GPG_TTY=$(tty)
  export GPG_TTY

  ssh_agent_setup
fi

# Start up usb auto mounting if present
if command -v dsbmc-cli > /dev/null 2>&1; then
  if ! pgrep -x -u "${USER}"  dsbmc-cli > /dev/null 2>&1; then
    nohup dsbmc-cli -a > /dev/null 2>&1 &
  fi
fi

if command -v rbenv > /dev/null 2>&1; then
  eval "$(rbenv init -)"
fi

# pyenv configs
if [ -d "${HOME}/.pyenv" ] || [ -L "${HOME}/.pyenv" ]; then
  export PYENV_ROOT="$HOME/.pyenv"
  export PATH="$PYENV_ROOT/bin:$PATH"
fi

if command -v pyenv 1> /dev/null 2>&1; then
  eval "$(pyenv init -)"
fi

# go specifics
if command -v go > /dev/null 2>&1; then
  export GOPATH="${HOME}/go"
  if [ ! -d "${HOME}/go/src" ]; then
    mkdir "${HOME}/go/src"
  fi
fi
