#!/bin/bash

format() {
	if [ $1 -ge 1000000 ]
	then
		printf '%d%s' $(($1/1000000)) "MB"
	elif [ $1 -ge 1000 ]
	then
		printf '%d%s' $(($1/1000)) "KB"
	else
		printf '%d%s' $1 "B"
	fi
}

#graph() {
#	i=0
#	#s=$(($1 / 20000 + 1))
#	#printf "%s " $1
#	s=$(bc <<< "$(bc -l <<< "l($1 + 1)/l(1.5)")/1")
#	
#	#printf $s
#
#	max_len=20
#
#	printf '|'
#	while [ $i -lt $s -a $i -lt $max_len ]
#	do
#		printf '%b' \\u2588
#		i=$(($i+1))
#	done
#	while [ $i -lt $max_len ]
#	do
#		printf ' '
#		i=$(($i+1))
#	done
#	printf '|   '
#}

graph() {
	while read value
	do
		printf "["
		ran=$((value * 50/$1))
		i=0
		while [ $i -lt $ran ]
		do
			printf "#"
			i=$(($i + 1))
		done
		while [ $i -lt 50 ]
		do
			printf "."
			i=$(($i + 1))
		done
		#echo $value
		printf '] '
		echo $(format $value)
	done < /tmp/graph
}

#printf '%5s %5s %8s %8s %7s %7s %7s %7s %6s %6s %7s %10s %10s %10s %6s\n' "dwl" "upl" "avg_dwl" "avg_upl" "time_d" "time_h" "time_m" "time_s" "load1" "load5" "load15" "mem_t" "mem_f" "mem_a" "graph"
printf '%6s %5s %6s %5s %11s %10s %11s %11s %11s %11s %11s %11s %4s %4s %4s %4s %5s %6s %6s %7s %7s %7s %6s\n' "dwl" "upl" "adwl" "aupl" "cpu0" "cpu1" "cpu2" "cpu3" "cpu4" "cpu5" "cpu6" "cpu7" "tmd" "tmh" "tmm" "tms" "load1" "load5" "load15" "mem_t" "mem_f" "mem_a" "graph"

#old_downloadt=$(echo | awk '{"cat /proc/net/dev | grep wlp2s0" | getline wireless; split(wireless, net, " "); print(net[2])}')
#old_uploadt=$(echo | awk '{"cat /proc/net/dev | grep wlp2s0" | getline wireless; split(wireless, net, " "); print(net[10])}')
old_downloadt=$(echo | awk '/wlp2s0/ {print($2)}' /proc/net/dev) 
old_uploadt=$(echo | awk '/wlp2s0/ {print($10)}' /proc/net/dev)
sum_download=0
sum_upload=0
time=1

rm /tmp/netd /tmp/netu 2>/dev/null

while true
do
	sleep 1 &
	#echo | awk '{"cat /proc/net/dev | grep wlp2s0" | getline wireless; split(wireless, net, " "); print(net[2], net[10])}'
	downloadt=$(echo | awk '{"cat /proc/net/dev | grep wlp2s0" | getline wireless; split(wireless, net, " "); print(net[2])}')
	uploadt=$(echo | awk '{"cat /proc/net/dev | grep wlp2s0" | getline wireless; split(wireless, net, " "); print(net[10])}')
	download=$(($downloadt - $old_downloadt))
	upload=$(($uploadt - $old_uploadt))
	printf '%20s   ' "download:"
	format $download
	echo
	printf '%20s   ' "upload:"
	format $upload
	echo
	printf '%20s   ' "average download:"
	format $(($sum_download / $time))
	echo
	printf '%20s   ' "average upload:"
	format $(($sum_upload / $time))
	echo
	echo $download >> /tmp/netd
	echo $upload >> /tmp/netu
	sum_download=$(($sum_download+$download))
	sum_upload=$(($sum_upload+$upload))
	old_downloadt=$downloadt
	old_uploadt=$uploadt
	printf 'cpu1 (usage / freq):   %s / %s\n' $(cat /proc/stat | grep cpu | tail -8 | head -1 | awk '{printf("%f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -8 | head -1 | awk '{printf("%f", $4)}')
	printf 'cpu2 (usage / freq):   %s / %s\n' $(cat /proc/stat | grep cpu | tail -7 | head -1 | awk '{printf("%f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -7 | head -1 | awk '{printf("%f", $4)}')
	printf 'cpu3 (usage / freq):   %s / %s\n' $(cat /proc/stat | grep cpu | tail -6 | head -1 | awk '{printf("%f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -6 | head -1 | awk '{printf("%f", $4)}')
	printf 'cpu4 (usage / freq):   %s / %s\n' $(cat /proc/stat | grep cpu | tail -5 | head -1 | awk '{printf("%f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -5 | head -1 | awk '{printf("%f", $4)}')
	printf 'cpu5 (usage / freq):   %s / %s\n' $(cat /proc/stat | grep cpu | tail -4 | head -1 | awk '{printf("%f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -4 | head -1 | awk '{printf("%f", $4)}')
	printf 'cpu6 (usage / freq):   %s / %s\n' $(cat /proc/stat | grep cpu | tail -3 | head -1 | awk '{printf("%f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -3 | head -1 | awk '{printf("%f", $4)}')
	printf 'cpu7 (usage / freq):   %s / %s\n' $(cat /proc/stat | grep cpu | tail -2 | head -1 | awk '{printf("%f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -2 | head -1 | awk '{printf("%f", $4)}')
	printf 'cpu8 (usage / freq):   %s / %s\n' $(cat /proc/stat | grep cpu | tail -1 | head -1 | awk '{printf("%f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -1 | head -1 | awk '{printf("%f", $4)}')
	printf '%20s   ' "uptime:"; awk '{s = $1 % 60; m = ($1 / 60) % 60; h = ($1 / 3600) % 24; d = ($1 / 3600 / 24) % 365; printf("%dd, %dh, %dm, %ds\n", d, h, m, s)}' /proc/uptime
	printf '%20s   %s\n' "load ( 1 min):" $(awk '{print $1}' /proc/loadavg)
	printf '%20s   %s\n' "load ( 5 min):" $(awk '{print $2}' /proc/loadavg)
	printf '%20s   %s\n' "load (15 min):" $(awk '{print $3}' /proc/loadavg)
	printf '%20s   %s\n' "total memory:" $(echo | awk '{"cat /proc/meminfo" | getline a; split(a, x, " "); printf("%s", x[2])}')
	printf '%20s   %s\n' "free memory:" $(echo | awk '{"cat /proc/meminfo | head -2 | tail -1" | getline a; split(a, x, " "); printf("%s", x[2])}')
	printf '%20s   %s\n' "available memory:" $(echo | awk '{"cat /proc/meminfo | head -3 | tail -1" | getline a; split(a, x, " "); printf("%s", x[2])}')
	#printf '%7s ' $(echo | awk '{"cat /proc/meminfo | head -2 | tail -1" | getline a; split(a, x, " "); printf("%s", x[2])}')
	#printf '%7s  ' $(echo | awk '{"cat /proc/meminfo | head -3 | tail -1" | getline a; split(a, x, " "); printf("%s", x[2])}')
	tail -14 /tmp/netd >/tmp/graph
	max_d=$(awk 'BEGIN{m=1}{if ($1>0+m) m=$1} END{print m}' /tmp/graph)
	echo -e '\ngraph download:'
	graph max_d
	tail -14 /tmp/netu >/tmp/graph
	max_u=$(awk 'BEGIN{m=1}{if ($1>0+m) m=$1} END{print m}' /tmp/graph)
	echo -e '\ngraph upload:'
	graph max_u
	#printf '%s' "net: "; echo $(format $download ) $(format $upload )
	#printf '%s' "avg: "; echo $(format $(($sum_download / $time))) $(format $(($sum_upload / $time)))
	#printf '%s' "uptime: "; awk '{s = $1 % 60; m = ($1 / 60) % 60; h = ($1 / 3600) % 24; d = ($1 / 3600 / 24) % 365; printf("d=%d, h=%d, m=%d, s=%d\n", d, h, m, s)}' /proc/uptime
	#printf '%s' "load: "; awk '{print $1, $2, $3}' /proc/loadavg
	#printf '%s' "mem: "; echo | awk '{"cat /proc/meminfo" | getline a; split(a, x, " "); printf("%s ", x[2]);
	#printf '%6s %5s ' $(format $download ) $(format $upload )
	#printf '%6s %5s ' $(format $(($sum_download / $time))) $(format $(($sum_upload / $time)))
	#printf '%6s/%4s' $(cat /proc/stat | grep cpu | tail -8 | head -1 | awk '{printf("%.3f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -8 | head -1 | awk '{printf("%.0f", $4)}')
	#printf '%6s/%4s ' $(cat /proc/stat | grep cpu | tail -7 | head -1 | awk '{printf("%.3f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -7 | head -1 | awk '{printf("%.0f", $4)}')
	#printf '%6s/%4s ' $(cat /proc/stat | grep cpu | tail -6 | head -1 | awk '{printf("%.3f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -6 | head -1 | awk '{printf("%.0f", $4)}')
	#printf '%6s/%4s ' $(cat /proc/stat | grep cpu | tail -5 | head -1 | awk '{printf("%.3f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -5 | head -1 | awk '{printf("%.0f", $4)}')
	#printf '%6s/%4s ' $(cat /proc/stat | grep cpu | tail -4 | head -1 | awk '{printf("%.3f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -4 | head -1 | awk '{printf("%.0f", $4)}')
	#printf '%6s/%4s ' $(cat /proc/stat | grep cpu | tail -3 | head -1 | awk '{printf("%.3f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -3 | head -1 | awk '{printf("%.0f", $4)}')
	#printf '%6s/%4s ' $(cat /proc/stat | grep cpu | tail -2 | head -1 | awk '{printf("%.3f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -2 | head -1 | awk '{printf("%.0f", $4)}')
	#printf '%6s/%4s ' $(cat /proc/stat | grep cpu | tail -1 | head -1 | awk '{printf("%.3f", 100 - ($5 * 100)/($2+$3+$4+$5+$6+$7+$8+$9+$10))}') $(cat /proc/cpuinfo | grep 'cpu MHz' | tail -1 | head -1 | awk '{printf("%.0f", $4)}')
	#printf '%s' "uptime: "; awk '{s = $1 % 60; m = ($1 / 60) % 60; h = ($1 / 3600) % 24; d = ($1 / 3600 / 24) % 365; printf("d=%d, h=%d, m=%d, s=%d\n", d, h, m, s)}' /proc/uptime
	#printf '%4s ' $(awk '{printf("%d", ($1 / 3600 / 24) % 365)}' /proc/uptime)
	#printf '%4s ' $(awk '{printf("%d", ($1 / 3600) % 24)}' /proc/uptime)
	#printf '%4s ' $(awk '{printf("%d", ($1 / 60) % 60)}' /proc/uptime)
	#printf '%4s ' $(awk '{printf("%d", $1 % 60)}' /proc/uptime)
	#printf '%s' "load: "; awk '{print $1, $2, $3}' /proc/loadavg
	#printf '%5s ' $(awk '{print $1}' /proc/loadavg)
	#printf '%5s ' $(awk '{print $2}' /proc/loadavg)
	#printf '%7s ' $(awk '{print $3}' /proc/loadavg)
	#printf '%7s ' $(echo | awk '{"cat /proc/meminfo" | getline a; split(a, x, " "); printf("%s", x[2])}')
	#printf '%7s ' $(echo | awk '{"cat /proc/meminfo | head -2 | tail -1" | getline a; split(a, x, " "); printf("%s", x[2])}')
	#printf '%7s  ' $(echo | awk '{"cat /proc/meminfo | head -3 | tail -1" | getline a; split(a, x, " "); printf("%s", x[2])}')
	##								 "cat /proc/meminfo" | getline b; split(b, x, " "); printf("%s ", x[2]);
	##								 "cat /proc/meminfo" | getline c; split(c, x, " "); printf("%s\n", x[2])}'
	#printf "\E[32m"	
	#graph $download
	#printf "\E[31m"	
	#graph $upload
	#printf "\E[0m"	
	printf "\n"
	time=$(($time+1))
	wait
	#sleep 1
done
