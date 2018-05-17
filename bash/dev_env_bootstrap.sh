#!/usr/bin/env bash

printf "${RESET}\n\n${YELLOW}boot strapping local dev enviroment...${RESET}\n\n"

function xcode_check() {
  printf "${UNDER_LINE}checking xcode-select\n${RESET}"
  xcode-select --version > /dev/null 2>&1 # https://unix.stackexchange.com/a/119650
  install_status=$?
  if [ $install_status = 0 ]; then
    printf "${RESET}\txcode-select installed\n"
  else
    printf "${RED}\txcode-select not installed\n"
    printf "${YELLOW}\tinstalling xcode-select (see https://www.howtogeek.com/211541/homebrew-for-os-x-easily-installs-desktop-apps-and-terminal-utilities/)\n"
    xcode-select --install
  fi
}

function brew_check() {
  printf "${UNDER_LINE}checking brew\n${RESET}"
  brew --version > /dev/null 2>&1 # https://unix.stackexchange.com/a/119650
  install_status=$?
  if [ $install_status = 0 ]; then
    printf "${RESET}\tbrew installed\n"
  else
    printf "${RED}\tbrew not installed\n"
    printf "${YELLOW}\tinstalling brew (see https://www.howtogeek.com/211541/homebrew-for-os-x-easily-installs-desktop-apps-and-terminal-utilities/)\n"
    ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    brew doctor
  fi
}

function zsh_check() {
  printf "${UNDER_LINE}checking oh-my-zsh\n${RESET}"
  zsh --version > /dev/null 2>&1 # https://unix.stackexchange.com/a/119650
  install_status=$?
  if [ $install_status = 0 ]; then
    printf "${RESET}\tzsh installed\n"
  else
    printf "${RED}\tzsh not installed\n"
    printf "${YELLOW}\tinstalling zsh (see https://www.howtogeek.com/211541/homebrew-for-os-x-easily-installs-desktop-apps-and-terminal-utilities/)\n"
    brew install zsh zsh-completions
  fi
}

function python3_check() {
  printf "${UNDER_LINE}checking python3\n${RESET}"
  which python
  ls -al /usr/local/bin/python
  ls -al $(which python)
  python3 --version > /dev/null 2>&1 # https://unix.stackexchange.com/a/119650
  install_status=$?
  if [ $install_status = 0 ]; then
    printf "${RESET}\tpython3 installed\n"
  else
    printf "${RED}\tpython3 not installed\n"
    printf "${YELLOW}\tinstalling python3 (see http://docs.aws.amazon.com/cli/latest/userguide/installing.html \n\tand http://docs.aws.amazon.com/cli/latest/userguide/cli-command-completion.html)\n"
    # brew install python3
  fi
}


function awscli_check() {
  printf "${UNDER_LINE}checking awscli\n${RESET}"
  awscli --version > /dev/null 2>&1 # https://unix.stackexchange.com/a/119650
  install_status=$?
  if [ $install_status = 0 ]; then
    printf "${RESET}\tawscli installed\n"
  else
    printf "${RED}\tawscli not installed\n"
    printf "${YELLOW}\tinstalling awscli ${RESET}(see http://docs.aws.amazon.com/cli/latest/userguide/installing.html \n\tand http://docs.aws.amazon.com/cli/latest/userguide/cli-command-completion.html)\n"
    brew install awscli
    pip3 install awscli --upgrade --user
    printf "\t${RED}ACTION REQUIRED: add 'source /usr/local/bin/aws_zsh_completer.sh' to ~/.zshrc\n"
    sleep 2
    printf "\nsource /usr/local/bin/aws_zsh_completer.sh\nsource /usr/local/share/zsh/site-functions\n" | pbcopy
    printf "\t${YELLOW}copied to clipboard\n"
    sleep 2
    printf "\t${GREEN}paste at end of ~/.zshrc${RESET}\n"
    sleep 2
    printf "\nopenning ~/.zshrc now . . .\n"
    sleep 2    
    vi ~/.zshrc
    printf "\t${GREEN}confirming installation running: source ~/.zshrc\n${RESET}"
    source ~/.zshrc
    printf "\t${GREEN}confirming installation running: brew doctor\n${RESET}"
    brew doctor
  fi
}

# https://github.com/moretension/duti
function duti_check() {
  printf "${UNDER_LINE}checking duti\n${RESET}"
  which duti
  install_status=$?
  if [ $install_status = 0 ]; then
    printf "${RESET}\tduti installed\n"
  else
    printf "${RED}\tduti not installed\n"
    printf "${YELLOW}\tinstalling duti (see https://github.com/moretension/duti)\n${RESET}"
    brew install duti
  fi
}

# https://developer.apple.com/library/content/documentation/Miscellaneous/Reference/UTIRef/Articles/System-DeclaredUniformTypeIdentifiers.html
function file_type_associations() {
  duti -s com.vscode js
  duti -s com.microsoft.VSCode public.python-script all
  duti -s com.microsoft.VSCode public.shell-script all
  duti -s com.microsoft.VSCode public.json all
  duti -s com.microsoft.VSCode public.text all
  duti -s com.microsoft.VSCode public.plain-text all
  duti -s com.microsoft.VSCode public.plain-text all
}

xcode_check
brew_check
zsh_check
awscli_check
duti_check
file_type_associations