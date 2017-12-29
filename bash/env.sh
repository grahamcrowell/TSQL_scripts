#! /usr/bin/sh

export RED=$(tput setaf 1)
export GREEN=$(tput setaf 2)
export YELLOW=$(tput setaf 3)
export CYAN=$(tput setaf 6)
export GREY=$(tput setaf 240)
export RESET_COLOR=$(tput sgr0)

export RELEASE_BRANCH=RELEASE-20171110-VEYRON
export HGDIR=$HOME/Documents/hg
export DIFFDIR=$HGDIR/code_review_diffs

export PATH=$HOME/Documents/git/scripts/bash:/usr/local/bin:$PATH
export PATH=$HOME/Documents/git/scripts/python:$PATH
