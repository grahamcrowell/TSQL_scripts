#!/usr/bin/env bash
printf "looking for public keys in ~/.ssh:\n";
public_key=`find ~/.ssh -type f | grep -E "\.pub$"`
result=$?
if [ ${result} -eq 0 ]
then
    printf "public key found: %s\n" ${public_key}
else
    echo "public key not found";
    
    echo "generate key";
    EMAIL="graham.crowell@rubikloud.com";
    ssh-keygen -t rsa -b 4096 -C "${EMAIL}" -f ~/.ssh/id_rsa  # -N "password"
    
    echo "start ssh-agent";
    eval "$(ssh-agent -s)"
    echo "add key to ssh agent"
    ssh-add ~/.ssh/id_rsa;
    printf "\n\nadd this to github.com\n\n";
    cat ~/.ssh/id_rsa.pub
    #    open "https://github.com/settings/keys"
fi
