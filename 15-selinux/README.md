# otus-linux-les-15  
## SELinux  

### Домашнее задание

Практика с SELinux
Цель: Тренируем умение работать с SELinux: диагностировать проблемы и модифицировать политики SELinux для корректной работы приложений, если это требуется.
1. Запустить nginx на нестандартном порту 3-мя разными способами:
- переключатели setsebool;
- добавление нестандартного порта в имеющийся тип;
- формирование и установка модуля SELinux.
К сдаче:
- README с описанием каждого решения (скриншоты и демонстрация приветствуются).

2. Обеспечить работоспособность приложения при включенном selinux.
- Развернуть приложенный стенд
https://github.com/mbfx/otus-linux-adm/tree/master/selinux_dns_problems
- Выяснить причину неработоспособности механизма обновления зоны (см. README);
- Предложить решение (или решения) для данной проблемы;
- Выбрать одно из решений для реализации, предварительно обосновав выбор;
- Реализовать выбранное решение и продемонстрировать его работоспособность.
К сдаче:
- README с анализом причины неработоспособности, возможными способами решения и обоснованием выбора одного из них;
- Исправленный стенд или демонстрация работоспособной системы скриншотами и описанием.
Критерии оценки:
Обязательно для выполнения:
- 1 балл: для задания 1 описаны, реализованы и продемонстрированы все 3 способа решения;
- 1 балл: для задания 2 описана причина неработоспособности механизма обновления зоны;
- 1 балл: для задания 2 реализован и продемонстрирован один из способов решения;
Опционально для выполнения:
- 1 балл: для задания 2 предложено более одного способа решения;
- 1 балл: для задания 2 обоснованно(!) выбран один из способов решения. 


### Решение домашнего задания

1. Запустить nginx на нестандартном порту 3-мя разными способами. 
1.1. переключатели setsebool  
  
Установка веб-сервера nginx ```yum install -y nginx```  
Замена в файле конфигурации nginx порт на 12345  ```nano /etc/nginx/nginx.conf```  
Узнаем какой логический тип включать```audit2why < /var/log/audit/audit.log```  
Полученная команда ```setsebool -P nis_enabled 1```  (-Р для работы после рестарта)
Теперь nginx успешно запускается  

1.2. добавление порт в имеющийся тип  

В результате ```semanage port -l | grep http_port_t``` видим, что порт 12345 не может работать по протоколу http  
Добавление порта в правилополитики ```semanage port -a -t http_port_t -p tcp 12345``` (для удаления весто -a использовать -d)
Результат:  
```
[root@host1 vagrant]# semanage port -l | grep http_port_t
http_port_t                    tcp      12345, 80, 81, 443, 488, 8008, 8009, 8443, 9000
```
Теперь nginx успешно запускается  

1.3. формирование и установка модуля SELinux

Компилирование модуля на основе лог файла аудита, в котором есть информация о запретах.  
```audit2allow -M httpd_add --debug < /var/log/audit/audit.log```  
Результат:  
```
[root@host1 vagrant]# audit2allow -M httpd_add --debug < /var/log/audit/audit.log
******************** IMPORTANT ***********************
To make this policy package active, execute:

semodule -i httpd_add.pp
```
Инсталляция модуля ```semodule -i httpd_add.pp```  
(выключить модуль ```semodule -d -v httpd_add```
включить модуль ```semodule -e -v httpd_add```
удалить модуль ```semodule -r httpd_add```)  

Проверка загрузки модуля ```semodule -l | grep http```  
Результат:  
```
[root@host1 vagrant]# semodule -l | grep http
httpd_add	1.0
```
Теперь nginx успешно запускается  

2. Обеспечить работоспособность приложения при включенном selinux

Загрузка данных из репозитория ```git clone https://github.com/mbfx/otus-linux-adm.git```  
Запуск машины ```vagrant up```  
Подключение к машине ```vagrant ssh client```
 
Попытка выполнить команды: 
```
nsupdate -k /etc/named.zonetransfer.key
server 192.168.50.10
zone ddns.lab 
update add www.ddns.lab. 60 A 192.168.50.15
send
```
Ошибка:  
```update failed: SERVFAIL```

Для решения проблемы необходимо создать модули по ошибкам  
Описание ошибок: ```/var/log/audit/audit.log```, ```/var/log/messages```, ```systemctl status named```  
  
Какой алгоритм решил проблему:
1. Нам нужно убрать все исключения и ошибки по линии SELINUX, чтобы система безопасности перестала ругаться
- выполняем команду ```audit2why < /var/log/audit/audit.log``` и видим:
```
[root@ns01 vagrant]# audit2why < /var/log/audit/audit.log
type=AVC msg=audit(1587231618.482:1955): avc:  denied  { search } for  pid=7268 comm="isc-worker0000" name="net" dev="proc" ino=33134 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:sysctl_net_t:s0 tclass=dir permissive=0

	Was caused by:
		Missing type enforcement (TE) allow rule.

		You can use audit2allow to generate a loadable module to allow this access.

type=AVC msg=audit(1587231618.482:1956): avc:  denied  { search } for  pid=7268 comm="isc-worker0000" name="net" dev="proc" ino=33134 scontext=system_u:system_r:named_t:s0 tcontext=system_u:object_r:sysctl_net_t:s0 tclass=dir permissive=0

	Was caused by:
		Missing type enforcement (TE) allow rule.

		You can use audit2allow to generate a loadable module to allow this access.

```
Затем ```audit2allow -M named-selinux --debug < /var/log/audit/audit.log``` и ```semodule -i named-selinux.pp```
В логе ```/var/log/messages``` видим ошибку и вариант ее решения: 
```
[root@ns01 vagrant]# cat /var/log/messages | grep ausearch
Apr 18 17:40:20 localhost python: SELinux is preventing /usr/sbin/named from search access on the directory net.#012#012*****  Plugin catchall (100. confidence) suggests   **************************#012#012If you believe that named should be allowed search access on the net directory by default.#012Then you should report this as a bug.#012You can generate a local policy module to allow this access.#012Do#012allow this access for now by executing:#012# ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0000#012# semodule -i my-iscworker0000.pp#012
```
После ввода предложенной команды ошибка появлялась несколько раз меня команду.  
Список команд:  
```ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0000 | semodule -i my-iscworker0000.pp```  
```ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0001 | semodule -i my-iscworker0001.pp```  
```ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0002 | semodule -i my-iscworker0002.pp```  
```ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0003 | semodule -i my-iscworker0003.pp```  
```ausearch -c 'isc-worker0000' --raw | audit2allow -M my-iscworker0004 | semodule -i my-iscworker0004.pp```  
  
Теперь ошибки есть в выводе команды ```systemctl status named```:  
Для ее решения нужно удалить файл ```/etc/named/dynamic/named.ddns.lab.view1.jnl```  
Теперь динамическое обновление выполняется успешно.  
  
  
  
Selinux блокировал доступ к обновлению файлов динамического обновления DNS сервера и файлам файлам ОС, к которым ```/usr/sbin/named``` обращается во время своей работы.  
Также необходимо удалить файл с расширением .jnl, в который записываются динамические обновления зоны. (tmp файлы тоже нужно удалить, т.к. данные сперва записываются во временныйфайл, который тоже блокируется)  
Временные файлы: ```ls -l /etc/named/dynamic/```  

Для решения проблем нужно использовать компиляцию модулей SELinux или изменения контекста безопасности для файлов.  
  
В крайнем случае можно выключить SELinux (некошерный вариант)  