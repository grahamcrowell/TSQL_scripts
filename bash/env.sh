#! /usr/bin/sh

RED=$(tput setaf 1)
GREEN=$(tput setaf 2)
YELLOW=$(tput setaf 3)
CYAN=$(tput setaf 6)
GREY=$(tput setaf 240)
RESET_COLOR=$(tput sgr0)

RELEASE_BRANCH=RELEASE-20170721-VEYRON
HGDIR=$HOME/Documents/hg/