#!/bin/bash

[ $# -lt 2 ] && echo "wrong number of args" >&2 && exit 1

PATTERN=$1
LOGFILE=$2
SLEEP=3600

while true; do
	if [ -f "$LOGFILE" ]; 
	then
		while read line; do
			if echo "$line" | grep -q "$PATTERN"; 
			then 
				worker=$(echo $line | cut -f5 -d' ')
				worker=${worker/worker-/""}
				worker=${worker/\:/""}
				echo "systemctl restart backend@$worker.service" >&2
				#systemctl restart "backend@$worker.service"
				break
			fi
		done < "$LOGFILE"
	else
		echo "provided files not found" >&2
	fi
	sleep $SLEEP
done

exit 0

