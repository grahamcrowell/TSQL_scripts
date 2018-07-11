#! /usr/bin/env bash

SCRIPT_NAME=`basename "$0"`

usage() { echo "Usage: $SCRIPT_NAME -s <data_regex_filter> [-f <filename_regex_filter>]" 1>&2; exit 1; }

function wheres_waldo() {
    FILE=$1
    CONTENT_GREP=$2
    # check if grep returns any matches...
    cat $FILE | grep -E "$CONTENT_GREP" > /dev/null 2>&1;
    found=$?;
    if [[ $found -eq 0 ]];
    then
        printf "found in: ${GREEN}%s${RESET}\n" "${FILE}";
        # print header line
        head -n 1 $FILE;
        # print matching lines
        cat $FILE | grep -E "$CONTENT_GREP" | grep --color "$CONTENT_GREP";
    fi;
    printf "${RESET}";
    return $found;
}

while getopts ":s:f:" ARGS; do
    case "${ARGS}" in
        s)
            s=${OPTARG}
            # ((d == "," || d == "\t")) || usage
            ;;
        f)
            f=${OPTARG}
            ;;
        *)
            usage
            ;;
    esac
done
shift $((OPTIND-1))

if [ -z "${s}" ]; then
    usage
else
    printf "\n\nsearching for: ${CYAN}${s}\n${RESET}"
fi

found_in_files=()

if [ -z "${f}" ]; then
        f=".*";
fi

FILES=`find * -maxdepth 1 -type f | grep -E "${f}"`
while read FILE; do
        wheres_waldo "${FILE}" "${s}";
        found=$?;
#       printf "\n\n${RED}found in: %s${RESET}\n" "${found_in_files[*]}";
        found_in_files+=("$FILE");
done <<< "$FILES";


printf "\n\n${GREEN}found in: %s${RESET}\n" "${found_in_files[*]}";
