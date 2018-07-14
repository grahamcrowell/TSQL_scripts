echo ""; echo ""; 
FILE=/Users/gcrowell/Documents/DelimitedLucene/test_data/indexing_tests/mock_tenant_root/20170625/Absence.csv;
s=Employee-1478;
cat $FILE | grep $s | while read LINE; 
do
    echo $LINE;
    let index=`echo $LINE | grep -b -o $s | sed 's/:.*$//'`; 
    echo $index; 
    let length=${#LINE};
    let end="${index}+${length}"; 
    echo $end;
    printf "${RESET}%s${GREEN}%s${RESET}%s\n" "white" "red" "white"
    echo "${LINE:0:$index}"
    echo "${LINE:$index:$length}"
    echo "${LINE:$end}"
done;