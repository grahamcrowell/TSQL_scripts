#! /usr/bin/env sh
####################################
# installation:
# 1. copy this to ~/env.sh
# 2. add following line to ~/.zshrc
# source ~/env.sh
####################################

echo "$0"
export SCRIPTS=`dirname $0`

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# linux brew
export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

alias chrome="google-chrome-stable --disable-web-security --user-data-dir ~/.config/google-chrome"
alias code="code --disable-gpu"

######################################################

export RESET='\e[0m' # No Color
export WHITE='\e[1;37m'
export BLACK='\e[0;30m'
export GREEN='\e[0;32m'
export YELLOW='\e[1;33m'
export RED='\e[0;31m'
export CYAN='\e[0;36m'

