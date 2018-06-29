#! /usr/bin/env bash
echo "$0"
# sourced in ~/.profile
# https://serverfault.com/a/261807

SCRIPTS_FOLDER=$HOME/Documents/git/scripts
SCRIPTS_FOLDER=$HOME/Documents/git/scripts
# folder shortcuts
export RELEASE_BRANCH=RELEASE-20180519-VEYRON
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
export PATH=$SCRIPTS_FOLDER/bash:/usr/local/bin:$PATH
export PATH=$SCRIPTS_FOLDER/python:$PATH
export PATH=$SCRIPTS_FOLDER/text_tools:$PATH
export PATH=$SCRIPTS_FOLDER/visier:$PATH
export PATH=$SCRIPTS_FOLDER/visier/deployment_tools:$PATH

# hg commands
export PATH=$SCRIPTS_FOLDER/hg:$PATH

export Demographics=~/Documents/hg/com.visiercorp.vserver/db_publish/DB/20140124/Demographics/0
alias cut="cut -d '|'"
export DEPLOYMENT=~/Documents/hg/deployment

rbtrc="REVIEWBOARD_URL = \"http://reviews.visier.corp/\"
REPOSITORY = \"deployment\"
REPOSITORY_TYPE = \"mercurial\""

export env=$0

export PATH="$HOME/.cargo/bin:$PATH"

function hgblog() {
    if [[ -z $1 ]];
    then
        BRANCH=`hg branch`
        if [[ $? -ne 0 ]]
        then
            return 1;
        fi
    else
        BRANCH="$1"
    fi
    hg log --graph --template "{label('custom.cyan',branches)} [{date|age} by {label('custom.bold',author)}]\n{label('custom.yellow',node|short)} {desc}\n\n" --rev "parents(min(branch($BRANCH))) or branch($BRANCH) or (max(branch('re:RELEASE-.*-VEYRON') and ancestors(branch($BRANCH))))"
    return 0;
}
