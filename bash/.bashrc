# Check umask if not set then set it sanely
[ "$(umask)" == "0000" ] && umask 0022

# If not running interactively, don't do anything
[ -z "$PS1" ] && return

# Get os platform
os_platform=$(uname -s)

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

# force commands that you entered on more than one line to be adjusted
# to fit on only one
shopt -s cmdhist

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# for setting history length see HISTSIZE bash(1)
HISTSIZE=8000

# recording each line of history as its issued
PROMPT_COMMAND="history -a"

# Ignore things in history
HISTIGNORE='top:ls:bg:fg:history'

# ignore duplicate commands and commands starting with whitespace
HISTCONTROL='ignoredups'

# timestamp of each command in history
# format example: 8000  2019-05-31 00:39:40 ps aux
HISTTIMEFORMAT='%F %T '

# less-isms

# Global less options
# Be mindful not to put "+Gg" here since less can't know its percent
# into the file it is until it knows how long the file is and this is
# problematic in pipes
# https://stackoverflow.com/questions/1049350/how-to-make-less-indicate-location-in-percentage
export LESS="-isM"

# For set preference for things using PAGER env var
export PAGER="less +Gg"

# Leave manpage place on screen after exit and set preference to read entire
# file and start back at the beginning to get percentage info
export MANPAGER="/usr/bin/env less -X +Gg"

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
alias def="type"
# Allows for piping vim doc
alias pvim="(trap 'rm ~/temp$$' exit; vim -c 'setlocal spell' ~/temp$$ >/dev/tty; cat ~/temp$$)"

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

# The only OSXism Im willing to tolerate 
if [ ${os_platform} != "Darwin" ];then
  alias pbcopy="xsel --clipboard"
fi

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
    # Exclude username in PS1 when not connected via SSH
    if [ "${SSH_TTY}" ]; then
      PS1='\[\033[01;36m\]\u@\h\[\033[01;37m\] \W \$\[\033[00m\] '
    else
      PS1='\[\033[01;36m\]\h\[\033[01;37m\] \W \$\[\033[00m\] '
    fi
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

# Borrowed from Davido
# Pretty cool for separating out pieces of a shell rc
rcfiles=$(ls ${HOME}/.bashrc.d/* 2>/dev/null)
for file in $rcfiles; do
    source $file
done
unset rcfiles
