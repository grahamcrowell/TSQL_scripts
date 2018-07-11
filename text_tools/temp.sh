#! /usr/bin/env bash

SCRIPT_NAME=`basename "$0"`

usage() {
    echo "Usage:"
}
verbose=false
while getopts :vh opt; do
    case $opt in 
        h) usage; exit ;;
        v) verbose=true ;;
        :) echo "Missing argument for option -$OPTARG"; exit 1;;
       \?) echo "Unknown option -$OPTARG"; exit 1;;
    esac
done

# here's the key part: remove the parsed options from the positional params
shift $(( OPTIND - 1 ))

printf "verbose: ${verbose}\n"
printf "verbose: ${verbose}\n"