#!/bin/sh

source env.sh

# https://stackoverflow.com/questions/226703/how-do-i-prompt-for-yes-no-cancel-input-in-a-linux-shell-script

while true; do
    read -p "Do you wish to install this program?" yn
    case $yn in
        [Yy]* ) echo "hello"; break;;
        [Nn]* ) echo "NO?"; exit;;
        * ) echo "Please answer yes or no.";;
    esac
done