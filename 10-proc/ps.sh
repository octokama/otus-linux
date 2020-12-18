#!/bin/bash

fmt="%-10s%-10s%-15s%-10s\n"
printf "$fmt" PID STAT TIME COMMAND

for proc in `ls /proc/ | egrep "^[0-9]" | sort -n`
do
    if [[ -f /proc/$proc/status ]]
        then
        PID=$proc

    COMMAND=`cat /proc/$proc/cmdline`
    STAT=`awk '/State/{print $2}' /proc/$proc/status`
    USER=`awk '/Uid/{print $2}' /proc/$proc/status`
    printf "$fmt" $PID  $STAT $USER "$COMMAND"
    fi
done
