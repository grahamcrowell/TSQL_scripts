#!/usr/bin/env bash

source common.sh

echo "\nchecking for MacOS prereqs\n"



function xcode_check() {
  printf "checking xcode-select\n"
  xcode-select --version > /dev/null 2>&1 # https://unix.stackexchange.com/a/119650
  install_status=$?
  if [ $install_status = 0 ]; then
    printf "${RESET_COLOR}\txcode-select installed\n"
  else
    printf "${RED}\txcode-select not installed\n"
    printf "${YELLOW}\tinstalling xcode-select (see https://www.howtogeek.com/211541/homebrew-for-os-x-easily-installs-desktop-apps-and-terminal-utilities/)\n"
    xcode-select --install
  fi
}

function brew_check() {
  printf "checking brew\n"
  brew --version > /dev/null 2>&1 # https://unix.stackexchange.com/a/119650
  install_status=$?
  if [ $install_status = 0 ]; then
    printf "${RESET_COLOR}\tbrew installed\n"
  else
    printf "${RED}\tbrew not installed\n"
    printf "${YELLOW}\tinstalling brew (see https://www.howtogeek.com/211541/homebrew-for-os-x-easily-installs-desktop-apps-and-terminal-utilities/)\n"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew doctor
  fi
}

function zsh_check() {
  printf "checking oh-my-zsh\n"
  zsh --version > /dev/null 2>&1 # https://unix.stackexchange.com/a/119650
  install_status=$?
  if [ $install_status = 0 ]; then
    printf "${RESET_COLOR}\tzsh installed\n"
  else
    printf "${RED}\tzsh not installed\n"
    printf "${YELLOW}\tinstalling zsh (see https://www.howtogeek.com/211541/homebrew-for-os-x-easily-installs-desktop-apps-and-terminal-utilities/)\n"
    brew install zsh zsh-completions
  fi
}

function python3_check() {
  printf "checking python3\n"
  which python
  ls -al /usr/local/bin/python
  ls -al $(which python)
  python3 --version > /dev/null 2>&1 # https://unix.stackexchange.com/a/119650
  install_status=$?
  if [ $install_status = 0 ]; then
    printf "${RESET_COLOR}\tpython3 installed\n"
  else
    printf "${RED}\tpython3 not installed\n"
    printf "${YELLOW}\tinstalling python3 (see http://docs.aws.amazon.com/cli/latest/userguide/installing.html \n\tand http://docs.aws.amazon.com/cli/latest/userguide/cli-command-completion.html)\n"
    # brew install python3
  fi
}


function awscli_check() {
  printf "checking awscli\n"
  awscli --version > /dev/null 2>&1 # https://unix.stackexchange.com/a/119650
  install_status=$?
  if [ $install_status = 0 ]; then
    printf "${RESET_COLOR}\tawscli installed\n"
  else
    printf "${RED}\tawscli not installed\n"
    printf "${YELLOW}\tinstalling awscli ${RESET_COLOR}(see http://docs.aws.amazon.com/cli/latest/userguide/installing.html \n\tand http://docs.aws.amazon.com/cli/latest/userguide/cli-command-completion.html)\n"
    brew install awscli
    pip3 install awscli --upgrade --user
    printf "\t${RED}ACTION REQUIRED: add 'source /usr/local/bin/aws_zsh_completer.sh' to ~/.zshrc\n"
    sleep 1
    printf "\nsource /usr/local/bin/aws_zsh_completer.sh\nsource /usr/local/share/zsh/site-functions\n" | pbcopy
    printf "\t${YELLOW}copied to clipboard\n"
    sleep 1
    printf "\t${GREEN}openning ~/.zshrc\n"
    sleep 1
    vi ~/.zshrc
    printf "\t${GREEN}confirming installation running: source ~/.zshrc\n${RESET_COLOR}"
    source ~/.zshrc
    printf "\t${GREEN}confirming installation running: brew doctor\n${RESET_COLOR}"
    brew doctor
  fi
}

xcode_check
brew_check
zsh_check
awscli_check
