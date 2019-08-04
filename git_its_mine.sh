#! /usr/bin/env bash

REPO_DIR=$PWD
printf "${YELLOW}updating git history of repo: ${REPO_DIR}\n${RESET}";
CORRECT_NAME=`git config --get user.name`
CORRECT_EMAIL=`git config --get user.email`
printf "COMMITTER and AUTHOR name: ${GREEN}${CORRECT_NAME}${RESET}\n"
printf "COMMITTER and AUTHOR email: ${GREEN}${CORRECT_EMAIL}${RESET}\n"

printf "\n${YELLOW}press ENTER to continue${RESET}\n"
read


git filter-branch -f --env-filter '
CORRECT_NAME="Graham Crowell"
CORRECT_EMAIL="graham.crowell@gmail.com"
if [ "$GIT_COMMITTER_EMAIL" != "$CORRECT_EMAIL" ] \
    || [ "$GIT_COMMITTER_NAME" != "$CORRECT_EMAIL" ] \
    || [ "$GIT_AUTHOR_EMAIL" != "$CORRECT_NAME" ] \
    || [ "$GIT_AUTHOR_NAME" != "$CORRECT_NAME" ]
then
    export GIT_COMMITTER_EMAIL="$CORRECT_EMAIL"
    export GIT_COMMITTER_NAME="$CORRECT_NAME"
    export GIT_AUTHOR_EMAIL="$CORRECT_EMAIL"
    export GIT_AUTHOR_NAME="$CORRECT_NAME"
fi
' --tag-name-filter cat -- --branches --tags