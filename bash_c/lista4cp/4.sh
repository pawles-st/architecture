#!/bin/bash

hash_files() {
	for f in "$1"/*
	do
		if [ -f "$f" ]
		then
			sha=$(sha256sum "$f" 2>/dev/null)
			if [ $? -eq 0 ]
			then
				stat --printf "%s " "$f" >> /tmp/hashes.txt
				#ls -l "$f" | awk '{printf("%s ", $5)}' >> /tmp/hashes.txt
				echo $sha >> /tmp/hashes.txt
			fi
		elif [ -d "$f" ]
		then
			hash_files "$f"
		fi
	done
}

rm /tmp/hashes.txt 2>/dev/null
hash_files $1

#sort -k 2,2 /tmp/hashes.txt
sort -k 2 /tmp/hashes.txt > /tmp/sorted_hashes.txt

#awk '{print $1, $2, $3}' /tmp/sorted_hashes.txt >> /tmp/grouped_hashes.txt
#awk '{split($0, x, " "); if(!seen[x[1]]++){print $1 $2 $3}} END{for (h in val) {print h,val[h]}}' /tmp/sorted_hashes.txt >> /tmp/grouped_hashes.txt
awk '{split($0, x, " "); s[x[2]] = $1; val[x[2]] = (val[x[2]] ? val[x[2]]" " : " ")x[3]} END{for (h in val) {print s[h], h,val[h]}}' /tmp/sorted_hashes.txt > /tmp/grouped_hashes.txt

awk 'NF>3{print $0}' /tmp/grouped_hashes.txt | sort -n -k 1 -r | awk '{$1=""; $2=""; print}' #> /tmp/duplicates.txt


