#!/bin/bash

function usage {
	echo "Usage: [-o operation < - | + | * | % >] [-n <numbers...>] [-d verbose]"
	exit 1 
}

function print_out {
   local MESSAGE="${*}"
   if [[ "${VERBOSE}" == true ]];then
      echo "${MESSAGE}"
   fi
}

function getopts-extra () {
    local i=1
    # if the next argument is not an option, then append it to array OPTARG
    while [[ ${OPTIND} -le $# && ${!OPTIND:0:1} != '-' ]]; do
        OPTARG[i]=${!OPTIND}
       	i=$((i+1))
	OPTIND=$((OPTIND+1))
    done
}


if [[ ${#} -eq 0 ]]; then
   usage
fi

optstring=":o:n:d"
while getopts ${optstring} arg; do
	case ${arg} in
		o)
			OPERATION="${OPTARG[0]}"
			if [[ "$OPERATION" != "%" && "$OPERATION" != "+" &&
				"$OPERATION" != "-" && "$OPERATION" != "*" ]]; then
				usage
			fi
			;;  
		n)
			getopts-extra "$@"
          		NUMBERS=( "${OPTARG[@]}" );;
		d)
			VERBOSE='true';;
		?)
			echo "Invalid option: -${OPTARG[0]}."
      			usage
      			;;
	esac
done

if [ "${#NUMBERS[@]}" -eq 0 ]; then
	echo "There should be at least one number!"
	usage
fi

RESULT="${NUMBERS[0]}"
case ${OPERATION} in
	+)
		for ((i=1; i < "${#NUMBERS[@]}"; i++)) do
			RESULT=$((RESULT + NUMBERS[i]))
		done;;
	-)
		for ((i=1; i < "${#NUMBERS[@]}"; i++)) do
			RESULT=$((RESULT - NUMBERS[i]))
		done;;
	\*)
		for ((i=1; i < "${#NUMBERS[@]}"; i++)) do
			RESULT=$((RESULT * NUMBERS[i]))
		done;;
	%)
		for ((i=1; i < "${#NUMBERS[@]}"; i++)) do
			RESULT=$((RESULT % NUMBERS[i]))
		done;;
esac

print_out "User: $USER"
print_out "Script: $0"
print_out "Operation: $OPERATION"
print_out "Numbers: ${NUMBERS[*]}" 
echo "Result: $RESULT"
