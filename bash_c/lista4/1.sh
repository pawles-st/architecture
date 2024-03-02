#!/bin/bash

printf "%8s %8s %40s %5s %10s %10s %8s %8s %5s\n" ppid pid comm state tty rss pgid sid files

for f in /proc/*[0-9]
do
	#awk '{n=split($0, x, "[()]"); c = substr(x[int(n/2 + 1)], 1, 40); split(x[n - 1], y, " "); "ls '$f'/fd | wc -w" | getline d; print(x[n])}' $f/stat
	awk '{n=split($0, x, "[()]"); c = substr(x[int(n/2 + 1)], 1, 40); split(x[n], y, " "); "ls '$f'/fd | wc -w" | getline d; printf("%8d %8d %40s %5c %10d %10ld %8d %8d %5s\n", y[2], x[1], c, y[1], y[5], y[22], y[6], y[4], d)}' $f/stat 2>/dev/null
	#awk '{c = substr($2, 1, 40); "ls '$f'/fd | wc -w" | getline n; printf("%8d %8d %40s %5c %10d %10ld %8d %8d %5s\n", $4, $1, c, $3, $7, $24, $8, $6, n)}' $f/stat
done
