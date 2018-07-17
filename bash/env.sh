#! /usr/bin/env bash
echo "$0"
# sourced in ~/.profile
# https://serverfault.com/a/261807

export RELEASE_BRANCH=RELEASE-20180519-VEYRON
# folder shortcuts
export SCRIPTS=`dirname $env`
export SCRIPTS=`dirname $SCRIPTS`
export HGDIR=$HOME/Documents/hg
export DIFFDIR=$HGDIR/diffs

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



# update path
export PATH="$HOME/.cargo/bin:$PATH"
export PATH=$SCRIPTS/bash:/usr/local/bin:$PATH
export PATH=$SCRIPTS/python:$PATH
export PATH=$SCRIPTS/text_tools:$PATH
export PATH=$SCRIPTS/visier:$PATH
export PATH=$SCRIPTS/visier/deployment_tools:$PATH
export PATH=$SCRIPTS/hg:$PATH
# add gnu grep (brew install grep)
export PATH="/usr/local/opt/grep/libexec/gnubin:$PATH";
export MANPATH="/usr/local/opt/grep/libexec/gnuman:$MANPATH"
# hg commands

export Demographics=~/Documents/hg/com.visiercorp.vserver/db_publish/DB/20140124/Demographics/0
alias cut="cut -d '|'"
export DEPLOYMENT=~/Documents/hg/deployment

rbtrc="REVIEWBOARD_URL = \"reviews.dev.visier.network/\"
REPOSITORY = \"deployment\"
REPOSITORY_TYPE = \"mercurial\"
API_TOKEN = \"b877988956986ac186390d69c51464e926dd2033\""

export esl="ESL/tenant-domains/src/main/scala/visier/data/domains/tenant"

