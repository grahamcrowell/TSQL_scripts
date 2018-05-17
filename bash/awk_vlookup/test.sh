#! /usr/bin/env sh

FILE1=file1.txt
FILE2=file2.txt
COL_FK=4
COL_PK=2
awk -f awk_script.awk $FILE1 $FILE2
