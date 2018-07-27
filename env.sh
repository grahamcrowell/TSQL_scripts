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

######################################################

platform='unknown'
unamestr=`uname`
if [[ "$unamestr" == 'Linux' ]]; then
   platform='linux'
elif [[ "$unamestr" == 'Darwin' ]]; then
   platform='mac'
fi

if [[ $platform == 'linux' ]]; then
       # linux brew
    export PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"
    export MANPATH="/home/linuxbrew/.linuxbrew/share/man:$MANPATH"
    export INFOPATH="/home/linuxbrew/.linuxbrew/share/info:$INFOPATH"
    PATH="/home/linuxbrew/.linuxbrew/bin:$PATH"

    alias chrome="google-chrome-stable --disable-web-security --user-data-dir ~/.config/google-chrome"
    function open_code() {
        code "$@" --disable-gpu
    }
    alias code=open_code

elif [[ $platform == 'mac' ]]; then
    export esl="ESL/tenant-domains/src/main/scala/visier/data/domains/tenant"
    export RELEASE_BRANCH=RELEASE-20180519-VEYRON
    # folder shortcuts
    export HGDIR=$HOME/Documents/hg
    export DIFFDIR=$HGDIR/diffs
    export Demographics=~/Documents/hg/com.visiercorp.vserver/db_publish/DB/20140124/Demographics/0
fi


export RESET='\e[0m' # No Color
export WHITE='\e[1;37m'
export BLACK='\e[0;30m'
export GREEN='\e[0;32m'
export YELLOW='\e[1;33m'
export RED='\e[0;31m'
export CYAN='\e[0;36m'

export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export CYAN=$(tput setaf 6)
export GREY=$(tput setaf 240)
export RESET_COLOR=$(tput sgr0)
export UNDER_LINE=$(tput sgr 0 1)
export BOLD=$(tput bold)
export RESET=$(tput sgr0)

export PATH="$SCRIPTS:$PATH"



