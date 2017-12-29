#! /bin/sh

echo "search all Employee files for missing Report To Id values";
DATAROOT="/esldata/WFF_usc6a"
LOGFILE="missing_manager.log";
TMP="tmp.log";
rm $TMP
echo "see: $LOGFILE"

# find . -wholename "*Employee*" -type f | while read name; 
# find . -regextype egrep -regex ".*[0-9]/Visier_Employee.*" -type f | while read name; 
# find . -regextype egrep -regex ".*[0-9]/Visier_Employee.*" -type f | while read name; 
# find . -wholename "*Employee*" -type f -exec grep -E ".*" '{}' \; -print | while read name; 
find $DATAROOT -type f | grep -P "$DATAROOT/[0-9]{8}/CMA_ACTUAL.*" | while read name; 
do
    printf "\n%s\n" $name
    printf "\t%s\n" $name >> $TMP
    # printf "%s|%s|%s\n" "Fiscal Period" "Reports To Id" "Employee Id"
    awk 'BEGIN { FS="|" } { printf("%s\n", $4); }' $name | sort | uniq
    awk 'BEGIN { FS="|" } { printf("%s\n", $4); }' $name | sort | uniq | wc -l
    awk 'BEGIN { FS="|" } { printf("%s\n", $4); }' $name | sort | uniq >> $TMP
    # awk 'BEGIN { FS="|" } { if( $46 == " " ) printf("%s|%s|%s\n", $1, $46, $2); } }' $name | wc -l
    # printf "Missing Manager Count:\t";
    # awk 'BEGIN { FS="|" } { if($46 == " ") { printf("%s|%s|%s\n", $1, $46, $2); } }' $name | wc -l | awk ' { printf("missing managers: %s /", $1) } '  >> $TMP
    # wc -l $name | awk ' { printf(" %s total records", $1) } '  >> $TMP
done;
# cat $TMP | sort > $LOGFILE;


