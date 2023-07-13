#!/bin/bash

function usage {
	echo "Usage: [-vrlu] [-s \"<A_WORD> <B_WORD>\"] [-i <input file>] [-o <output file>]"
	exit 1
}

if [[ $# -eq 0 ]]; then
    usage
fi

optstring="vrlus:i:o:"
while getopts ${optstring} arg; do
	case ${arg} in
		v)
			CHANGE_CASE='true';;
		r)
			REVERSE='true';;
		l)
			LOWER='true';;
		u)
			UPPER='true';;
		s)
			SUBSTITUTION='true'
			read -ra WORDS <<< "$OPTARG"
			if [ ! ${#WORDS[@]} -eq "2" ]; then
				usage
			fi;;
		i)
			INPUT="$OPTARG";;
		o)
			OUTPUT="$OPTARG";;
	esac
done

if [[ ! -e "$INPUT" || ! -r "$INPUT" ]]; then
        echo "Cannot access input file!"
        exit 1
fi

if [ -z "$OUTPUT" ]; then
	usage
fi

if [ "$CHANGE_CASE" == 'true' ]; then
	while IFS= read -n1 letter; do
		if [[ "$letter" == [[:upper:]] ]]; then
			echo -n "${letter}" | tr '[:upper:]' '[:lower:]' >> "$OUTPUT"
		elif [[ "$letter" == [[:lower:]] ]]; then
			echo -n "${letter}" | tr '[:lower:]' '[:upper:]' >> "$OUTPUT"
		elif [[ $letter == '' ]]; then
                	echo  >> "$OUTPUT"
		else
			echo -n "$letter" >> "$OUTPUT"
		fi
	done < "$INPUT"
fi

if [ "$UPPER" == 'true' ]; then
	tr '[:lower:]' '[:upper:]' < "$INPUT" > "$OUTPUT"
fi

if [ "$LOWER" == 'true' ]; then
	tr '[:upper:]' '[:lower:]' < "$INPUT" > "$OUTPUT"
fi

if [ "$SUBSTITUTION" == 'true' ]; then
	if [[ "$CHANGE_CASE" == 'true' || "$UPPER" == 'true' || "$LOWER" == 'true' ]]; then
		sed -i '' s/"${WORDS[0]}"/"${WORDS[1]}"/gI "$OUTPUT"
	else 
		sed s/"${WORDS[0]}"/"${WORDS[1]}"/gI "$INPUT" > "$OUTPUT"
	fi	
fi

if [ "$REVERSE" == 'true' ]; then  
	if [[ "$CHANGE_CASE" == 'true' || "$UPPER" == 'true' || "$LOWER" == 'true' || "$SUBSTITUTION" == 'true' ]]; then
		nl "$OUTPUT" | sort -nr | cut -f 2-
	else
		tail -r "$INPUT" > "$OUTPUT"
	fi
fi
