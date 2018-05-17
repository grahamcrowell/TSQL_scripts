#! /usr/bin/env bash
echo "$0"
# sourced in ~/.profile
# https://serverfault.com/a/261807

SCRIPTS_FOLDER=$HOME/Documents/git/scripts

# colour shortcuts: https://linuxtidbits.wordpress.com/2008/08/11/output-color-on-bash-scripts/
export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export CYAN=$(tput setaf 6)
export GREY=$(tput setaf 240)
export RESET_COLOR=$(tput sgr0)
export UNDER_LINE=$(tput sgr 0 1)
export BOLD=$(tput bold)
export RESET=$(tput sgr0)

# folder shortcuts
export RELEASE_BRANCH=RELEASE-20180119-VEYRON
export HGDIR=$SCRIPTS_FOLDER/hg
export DIFFDIR=$HGDIR/code_review_diffs

# update path
export PATH=$SCRIPTS_FOLDER/bash:/usr/local/bin:$PATH
export PATH=$SCRIPTS_FOLDER/python:$PATH
export PATH=$SCRIPTS_FOLDER/text_tools:$PATH

# hg commands
export PATH=$SCRIPTS_FOLDER/hg:$PATH

export Demographics=~/Documents/hg/com.visiercorp.vserver/db_publish/DB/20140124/Demographics/0
alias cut="cut -d '|'"
export DEPLOYMENT=~/Documents/hg/deployment

rbtrc="REVIEWBOARD_URL = \"http://reviews.visier.corp/\"
REPOSITORY = \"deployment\"
REPOSITORY_TYPE = \"mercurial\""

export env=$0

source /usr/local/share/zsh-autosuggestions/zsh-autosuggestions.zsh
export PATH="$HOME/.cargo/bin:$PATH"