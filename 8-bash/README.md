# otus-linux-les-8
## Bash


### Файлы  
1. [parse_log.sh] - основной скрипт, который парсит файл логов  
2. [access-4560-644067.log] - файл логов  
3. [last_line] - файл, в котором хранится последняя обработаная строка  
4. [mail_text] - сообщение  
 
Для защиты от мультизапуска в `crontab -e` нужно прописать  
```
0 * * * * /usr/bin/flock -xn /var/lock/parse_log.lock -c 'sh /root/parse_log.sh'
```
