#!/bin/bash

# https://stackoverflow.com/questions/16726779/how-do-i-get-the-total-cpu-usage-of-an-application-from-proc-pid-stat
HZ=$(getconf CLK_TCK) # number of ticks per second

(
echo "PID|TTY|STAT|TIME|COMMAND";

for pid in `ls /proc | grep -E "^[0-9]*$"`; do
    if [ -d /proc/$pid ]; then
    # man proc
        stat=$(< /proc/$pid/stat)
        tty=$(echo "$stat" | awk -F" " '{print $7}')
        state=$(echo "$stat" | awk -F" " '{print $3}')
        comm=$(echo "$stat" | awk -F" " '{print $2}')
    #calc time
        utime=$(echo "$stat" | awk -F" " '{print $14}')
        stime=$(echo "$stat" | awk -F" " '{print $15}')
	    total_time=$((utime + stime))
	    time=$((total_time / HZ)) #seconds

        echo "${pid}|${tty}|${state}|${time}|${comm}"
    fi
done 
)  | sort -n | column -t -s "|"
