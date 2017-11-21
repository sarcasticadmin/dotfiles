# Test comment
# If not running interactively, don't do anything
[ -z "$PS1" ] && return

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

  if [ ${os_platform} == "FreeBSD" ];then
    alias ls='ls -G'
  else
    alias ls='ls --color=auto'
  fi

  alias grep='grep --colour=auto'
else
  # show root@ when we don't have colors
  PS1='\u@\h \W \$ '
fi

# Try to keep environment pollution down, EPA loves us.

# Generate a random password
#  $1 = number of characters; defaults to 32
#  $2 = include special characters; 1 = yes, 0 = no; defaults to 1
function randpass() {
  [ "$2" == "0" ] && CHAR="[:alnum:]" || CHAR="[:graph:]"
  cat /dev/urandom | tr -cd "$CHAR" | head -c ${1:-32}
  echo
}

function fingerprints() {
  local file="$1"
  while read l; do
    [[ -n $l && ${l###} = $l ]] && ssh-keygen -l -f /dev/stdin <<<$l
  done < $file
}

# AWS CLI bash stuff
if [ -f "$HOME/.bash_aws" ]; then
  source "$HOME/.bash_aws"
fi

# Disable stopping flowcontrol
stty -ixon

# gpg-agent stuff
if [ ${ENABLE_GPG:-1} -eq 0 ]; then
  # Is daemon running?
  if ! pgrep -x -u "${USER}" gpg-agent >/dev/null 2>&1; then
    eval $(gpg-agent --daemon)
  fi
  # gpg pinentry
  GPG_TTY=$(tty)
  export GPG_TTY
  # Make sure ssh uses the right sock
  unset SSH_AUTH_SOCK
  if [ -e "${HOME}/.gnupg/S.gpg-agent.ssh" ]; then
    SSH_AUTH_SOCK="${HOME}/.gnupg/S.gpg-agent.ssh"
  else
    SSH_AUTH_SOCK="/var/run/user/$(id -u)/gnupg/S.gpg-agent.ssh"
  fi
  export SSH_AUTH_SOCK
fi
