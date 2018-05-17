    {# Utility Scripts

## HG Snippets

### Non-Release Branches Merged In 

```
RELEASE_BRANCH=RELEASE-20170721-VEYRON
TASK_BRANCH=use1p_DM-12723
hg log -r "parents(branch($TASK_BRANCH)) and not branch($RELEASE_BRANCH) and not branch($TASK_BRANCH)"
```

hg log --graph -r "(parents('use1p_DM-12723') or branch(use1p_DM-12723))" --template "branch:\t{branch}\n  rev:\t{node|short}\n{revset('parents(%d)', rev) % 'parent:\t{branch}\n  rev:\t{node|short}\n'}author:\t{author}\ndesc:\t{desc}\n\n"


hg log --graph -r "(parents('use1p_DM-12723') or branch(use1p_DM-12723))" --template "date:\t{date|shortdate}\nbranch:\t{branch}\n  rev:\t{node|short}\n{revset('parents(%d)', rev) % 'parent:\t{branch}\n  rev:\t{node|short}\n'}author:\t{author}\ndesc:\t{desc}\n\n"

## Git Snippets

`git clone https://github.com/treasureapp/frontend`

## Bash Snippets

### Pipe filenames to command

`find . -wholename "./src/*/*.js" | while read i; do echo $i"x"; done;`

`find . -name "*Screen Shot 2017-11*" | xargs -I '{}' mv '{}' ./screenshots/Nov/`

`ls -la | awk ' { print $10 } ' | xargs -I '{}' echo '{}'`

`du -h --exclude "data_sbx" --all | awk ' { print NR " " $0 } '`

### Read delimited files

#### Print numbered header
NAME=
`head -n 1 $NAME | awk 'BEGIN { FS="|" } { for(i = 1; i <= NF; i++) { printf("%d  %s\n", i, $i) } } '`

#### Print sample of a column
COL_ID=
`head -n 10 $NAME | awk 'BEGIN { FS="|" } { printf("%s", $COL_ID) }'`

#### Print column value histogram
COL_ID=
`cat $NAME | awk 'BEGIN { FS="|" } { printf("%s", $COL_ID) }' | sort -n | uniq -c`

### User Menu
whiptail --title "tiel " --menu "pick one" 10 100 10 $(ls | awk ' { printf("\"%s\" \"fuck\" ", $0); } ')$(ls | awk ' { printf("\"%s\" \"fuck\" ", $0); } ')

foobar=$(whiptail --inputbox "Enter some text" 10 30 3>&1 1>&2 2>&3)

whiptail --title "tiel " --menu "pick one" 10 100 10 $(ls | awk ' { gsub(/ /, "_"); printf("%s abc ", $0, $0); } ')

