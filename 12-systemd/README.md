# otus-linux-les-12
## Systemd


### Задания  
1. Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова (файл лога и ключевое слово должны задаваться в /etc/sysconfig);  

[logchecker] - файл конфигурацции для /etc/sysconfig/  
[logchecker.sh] - скрипт, который проверяет лог на содержание слова  
[logchecker.service] - юнит для сервиса  
[logchecker.timer] - юнит для таймера  

активация:  
```
systemctl enable logchecker.timer
systemctl enable logchecker.service
systemctl start logchecker
```
  
чтение лога:  
```
tail -f /var/log/messages
```
  
2. Из репозитория epel установить spawn-fcgi и переписать init-скрипт на unit-файл (имя service должно называться так же: spawn-fcgi);  
  
установка spawn-fcgi и необходимые для него пакеты  
```
yum install epel-release -y && yum install spawn-fcgi php php-cli mod_fcgid httpd -y
```
  
в `/etc/sysconfig/spawn-fcgi` необходимо раскомментировать переменные SOCKET и OPTIONS  
  
[spawn-fcgi.service] - юнит для сервиса  
```
systemctl start spawn-fcgi
systemctl status spawn-fcgi
```
  
3. Дополнить unit-файл httpd (он же apache) возможностью запустить несколько инстансов сервера с разными конфигурационными файлами;  
  
Дополнить файл `/usr/lib/systemd/system/httpd.service`:  
дописать модификатор %I в описании [Service] в `EnvironmentFile=/etc/sysconfig/httpd-%I`  
теперь можно добавлять разные файлы конфигурации в /etc/httpd/conf, например one, two, three перед стартом httpd:
```
systemctl start httpd@one.service
```
  
4\*. Скачать демо-версию Atlassian Jira и переписать основной скрипт запуска на unit-файл.  
  
установка java: `yum install java-1.7.0-openjdk-devel -y`  
скачивание и установка Atlassian Jira:  
```
wget https://www.atlassian.com/software/jira/downloads/binary/atlassian-jira-software-7.12.3.tar.gz
tar -zxvf atlassian-jira-software-7.12.3.tar.gz && cd atlassian-jira-software-7.12.3-standalone/
```
  
создание конфига: `/etc/sysconfig/jira`
[jira] - файл с конфигом для юнита  
[jira.service] - юнит для сервиса  
  
запуск и проверка:
```
systemctl enable jira.service
systemctl start jira
systemctl status jira
```



[logchecker]:https://github.com/octokama/otus-linux/blob/main/12-systemd/1/logchecker
[logchecker.sh]:https://github.com/octokama/otus-linux/blob/main/12-systemd/1/logchecker.sh
[logchecker.service]:https://github.com/octokama/otus-linux/blob/main/12-systemd/1/logchecker.service
[logchecker.timer]:https://github.com/octokama/otus-linux/blob/main/12-systemd/1/logchecker.timer
[spawn-fcgi.service]:https://github.com/octokama/otus-linux/blob/main/12-systemd/2/spawn-fcgi.service
[jira]:https://github.com/octokama/otus-linux/blob/main/12-systemd/4/jira
[jira.service]:https://github.com/octokama/otus-linux/blob/main/12-systemd/4/jira.service
