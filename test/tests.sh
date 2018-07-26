#! /usr/bin/env bash

# source ~/.profile
# source ~/.bashrc
# chmod 777 ../*

CHILD_FILE=data/child.txt
PARENT_FK=3

PARENT_FILE=data/parent.txt
PK=2
OUTPUT_COLUMN=4

# fk_array=($(column_select ${PARENT_FK} ${CHILD_FILE} | sort | uniq))
# echo ${fk_array[0]}

column_select ${PARENT_FK} ${CHILD_FILE} | sort | uniq | sed '/^$/d' | xargs -I '{}' lookup $PK '{}' $OUTPUT_COLUMN $PARENT_FILE
column_select ${PARENT_FK} ${CHILD_FILE} | sort | uniq | sed '/^$/d'