#!/bin/bash

#получение последней обработанной строки
last_line=$(cat ./last_line)
# получение последнего номера строки в файле
all_lines=$(wc -l ./access-4560-644067.log | awk '{print $1}')
# запись количества обрабатываемых строк
echo $all_lines > ./last_line

# получение даты и времени первой и последней записей в логе для этой итерации
time_start=$(awk '{print $4 $5}' access-4560-644067.log | sed 's/\[//; s/\]//' | sed -n "$(($last_line+1))"p)
time_end=$(awk '{print $4 $5}' access-4560-644067.log | sed 's/\[//; s/\]//' | sed -n "$all_lines"p)

# получение ip адресов X и количество вызовов
ip_req=$(awk "NR>$last_line"  access-4560-644067.log | awk '{print $1}' | sort | uniq -c | sort -rn | awk '{ print "Количество запросов:" $1, "ip:" $2 }')
# получение адресов Y
url_req=$(awk "NR>$last_line"  access-4560-644067.log | awk '{print $7}' | sort | uniq -c | sort -rn | awk '{ print "Количество запросов:" $1, "url:" $2 }')
# получение ошибок
errors=$(awk "NR>$last_line"  access-4560-644067.log | awk '{print $9}' | sort | uniq -c | sort -rn | awk '{ if ( $2 != 200 && $2 != "\"-\"" ) { print "Количество ошибок:" $1, "код:" $2 } }')

echo -e "Период: $time_start-$time_end\n\n"Адреса X:"\n$ip_req\n\n"Адреса Y:"\n$url_req\n\n"Ошибки:"\n$errors" | mail -s "Log Info" root@localhost



