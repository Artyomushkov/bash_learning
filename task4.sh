#!/bin/bash

function usage {
	echo "Usage: -s <shift> -i <input file> -o <output file>"
	exit 1
}

if [[ ${#} -ne 6 ]]; then
	usage
fi

optstring=":s:i:o:"
while getopts ${optstring} arg; do
	case ${arg} in
		s)
			SHIFT="${OPTARG}";;
		i)
			INPUT="${OPTARG}";;
		o)
			OUTPUT="${OPTARG}";;
		?)
			echo "Invalid option: -${OPTARG}."
			usage;;
	esac
done

if [[ ! -e "$INPUT" || ! -r "$INPUT" ]]; then
	echo "Cannot access input file!"
	exit 1
fi

while IFS= read -n 1 letter; do
	if [[ $letter == [[:alpha:]] ]]; then
		ascii=$(printf %d \'"$letter")
      		((ascii+=SHIFT))
      		cipher_letter=$(printf "\\$(printf "%03o" "$ascii")")
      		echo -n "$cipher_letter" >> "$OUTPUT"
	elif [[ $letter == '' ]]; then
		echo  >> "$OUTPUT"
	else 
		echo -n "$letter" >> "$OUTPUT"
	fi
done < "$INPUT"
