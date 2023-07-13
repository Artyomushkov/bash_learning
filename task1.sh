#!/bin/bash

INDEX=$1

funcFib() {
	if [ "$1" -eq 0 ]; then
		return 0
	fi
	local pre=0
	local cur=1
	local i=1
	while [ ! $i -eq "$1" ]; do
		tmp=$((pre + cur))
		pre=$cur
		cur=$tmp
		i=$((i + 1))
	done
	return $cur
}

if [ ! $# -eq 1 ]; then
	echo "The script should have one argument"
	exit 1
fi
funcFib "$INDEX"
echo "The $INDEX fibbonacci number is $?" 
