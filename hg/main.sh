echo "repo_summary" $@
echo $PWD
printf "change working directory to: " $@ "\n\n"
cd $1


message_fmt="\n\n*********************************\n%s\n*********************************\n"

stage_name="branch name:"
printf "$message_fmt" "$stage_name"
hg branch
stage_name="status:"
printf "$message_fmt" "$stage_name"
hg status
stage_name="summary"
printf "$message_fmt" "$stage_name"
hg summary
stage_name="log"
printf "$message_fmt" "$stage_name"
hg log -l 5 --user gcrowell
# echo $PWD