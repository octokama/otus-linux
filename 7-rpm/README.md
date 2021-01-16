# otus-linux-les-7
## rpm


### Задания  
    Размещаем свой RPM в своем репозитории
    Цель: Часто в задачи администратора входит не только установка пакетов, но и сборка и поддержка собственного репозитория. Этим и займемся в ДЗ.
    1) создать свой RPM (можно взять свое приложение, либо собрать к примеру апач с определенными опциями)
    2) создать свой репо и разместить там свой RPM
    реализовать это все либо в вагранте, либо развернуть у себя через nginx и дать ссылку на репо 

    * реализовать дополнительно пакет через docker
    Критерии оценки: 5 - есть репо и рпм
    +1 - сделан еще и докер образ

##### Для запуска стенда использовать Vagrantfile [Vagrantfile] и скрипт [install.sh]: `vagrant up`. 
##### Пояснение  
1. Создание своего RPM
- Устанавка пакетов: ```yum install -y redhat-lsb-core wget rpmdevtools rpm-build createrepo yum-utils openssl-devel zlib-devel pcre-devel gcc```  
- Загрузка src.rpm - ```wget https://nginx.org/packages/centos/7/SRPMS/nginx-1.14.1-1.el7_4.ngx.src.rpm```  
- При использовании этой команды с параметром -i, распаковываются src и spec файл: ```rpm -i nginx-1.14.1-1.el7_4.ngx.src.rpm```  
- Переходим в каталог rpmbuild:  
- В папке SPECS лежит spec-файл. Файл, который описывает что и как собирать.  
- Открываем файл ```nano SPECS/nginx.spec``` и добавляем в секцию %build необходимый нам модуль OpenSSL:  
```
%build
./configure %{BASE_CONFIGURE_ARGS} \
    --with-cc-opt="%{WITH_CC_OPT}" \
    --with-ld-opt="%{WITH_LD_OPT}" \
    --with-openssl=/root/rpmbuild/openssl-1.1.1i
make %{?_smp_mflags}
%{__mv} %{bdir}/objs/nginx \
    %{bdir}/objs/nginx-debug
./configure %{BASE_CONFIGURE_ARGS} \
    --with-cc-opt="%{WITH_CC_OPT}" \
    --with-ld-opt="%{WITH_LD_OPT}"
make %{?_smp_mflags}
```
- Установка зависимостей - ```yum-builddep SPECS/nginx.spec```  
- Сборка - ```rpmbuild -bb SPECS/nginx.spec```  
- Видим два собранных пакета:  
- Установка rpm пакета: ```yum localinstall -y RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm```  
- Запуск nginx - ```systemctl start nginx```  

2. Создание своего репозитория
- Создание папки в корне nginx - ```mkdir /usr/share/nginx/html/repo```  
- Копирование скомпилированного пакета nginx в папку с будущим репозиторием - ```cp rpmbuild/RPMS/x86_64/nginx-1.14.1-1.el7_4.ngx.x86_64.rpm /usr/share/nginx/html/repo/```  
- Загрузка доп. пакет - ```wget http://www.percona.com/downloads/percona-release/redhat/0.1-6/percona-release-0.1-6.noarch.rpm -O /usr/share/nginx/html/repo/percona-release-0.1-6.noarch.rpm```  
- Создание репозитория - ```createrepo /usr/share/nginx/html/repo/``` и ```createrepo --update /usr/share/nginx/html/repo/```  
- Правка /etc/nginx/conf.d/default.conf:
```
location / {
root /usr/share/nginx/html;
index index.html index.htm;
autoindex on;
}
```
- Проверка синтаксиса ```nginx -t``` и ```nginx -s reload```
- Просмотр пакетов через HTTP - ```lynx http://localhost/repo/``` или ```curl -a http://localhost/repo/```
- Для теста репозитория: создание файла ``` /etc/yum.repos.d/otus.repo``` с содержимым:
```
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
```
- Посмотр подключенного репозитория - ```yum repolist enabled | grep otus``` и ```yum list | grep otus``` или ```yum list --showduplicates | grep otus```  
- `yum clean all` и `yum list --showduplicates | grep otus`


[Vagrantfile]:https://github.com/octokama/otus-linux/tree/main/7-rpm/Vagrantfile
[install.sh]:https://github.com/octokama/otus-linux/tree/main/7-rpm/install.sh