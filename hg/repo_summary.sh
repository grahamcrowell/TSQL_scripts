echo "repo_summary" $@
echo $PWD
printf "change working directory to: " $@ "\n\n"
cd $1
echo $PWD


hg branch
hg status
hg summary


