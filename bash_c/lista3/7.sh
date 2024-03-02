#!/bin/bash

path=${1:-"."}

for fullpath in $path/*
do
	file=$(basename "$fullpath")
	newfile=$(echo "$file" | tr [A-Z] [a-z])
	mv -- "$fullpath" "$path/$newfile" 2>/dev/null
done
