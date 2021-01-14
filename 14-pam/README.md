# otus-linux-les-14
## PAM


### Задания  
1. Запретить всем пользователям, кроме группы admin логин в выходные (суббота и воскресенье), без учета праздников  

Создание групп `admin` и `testusers` и добавление пользователей test1, test2 и odmin:
 
```
$ groupadd myusers
$ groupadd admin
$ useradd -g testusers test1
$ useradd -g testusers test2
$ useradd -g admin odmin
```

Добавление правила в /etc/security/time.conf:

```
sshd;*;!admin;!Wk0000-2400
```

Настройка PAM, добавив правило в /etc/pam.d/sshd

```
account required pam_time.so
```

Пробуем зайти по ssh в сб или вск получаем failed:

```
$ ssh test1@localhost

test1@localhost's password:
Authentication failed.
```
