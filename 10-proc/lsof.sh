#!/bin/bash

fmt="%-10s %-20s %-30s %15s\n"

printf "$fmt" PID USER NAME COMM

for proc in `ls  /proc/ | egrep "^[0-9]" | sort -n`
    do
    procdir="/proc/$proc"
    if [[ -d "$procdir" ]]
        then
        user=`awk '/Uid/{print $2}' /proc/$proc/status`

        command=`cat /proc/$proc/comm`

        if [[ user -eq 0 ]]
            then
            UserName='root'
            else
            UserName=`grep $user /etc/passwd | awk -F ":" '{print $1}'`
        fi

        mapfiles=`readlink /proc/$proc/map_files/*; readlink /proc/$proc/cwd`
        if ! [[ -z "$mapfiles" ]]
            then
            for num in $mapfiles
            do
            printf "$fmt" $proc $UserName $num $command
            done
        fi
   fi
done
