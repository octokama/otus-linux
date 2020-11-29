# otus-linux-les-3
## Работа с NFS
Для поднятия машины из Vagrantfile `vagrant up` и подключение `vagrant ssh nfs-server` и `vagrant ssh nfs-client`

### 1. Настройка сервера  
Установка пакетов необходимых для функционирования сервера  
`sudo yum install -y nfs-utils`  
 
Включение автозапуска необходимых сервисов  
```
sudo systemctl enable rpcbind  
sudo systemctl enable nfs-server  
sudo systemctl enable rpc-statd  
sudo systemctl enable nfs-idmapd
```
 
Запуск сервисов  
```
sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo systemctl start rpc-statd
sudo systemctl start nfs-idmapd
```
 
Создать директорию для экспорта. Установить необходимые разрешения (0777)  
```
sudo mkdir -p /export/shared
sudo chmod 0777 /export/shared
```

Создание каталога upload и предоставление прав на запись
```
sudo mkdir /export/shared/upload
sudo chmod a+w /export/shared/upload
```
 
Описание экспортируемой директории в конфигурационном файле /etc/etcports  
```
cat << EOF | sudo tee /etc/exports
/export/shared  192.168.10.0/24(rw,async)
EOF
```
 
Применение изменений конфигурации  
`sudo exportfs -ra`  
 
Включение и запуск firewalld  
```
sudo systemctl enable firewalld
sudo systemctl start firewalld
systemctl status firewalld
```
 
Открытие необходимых портов посредством включения соответствующих сервисов в firewalld  
```
{
  sudo firewall-cmd --permanent --add-service=nfs3
  sudo firewall-cmd --permanent --add-service=mountd
  sudo firewall-cmd --permanent --add-service=rpc-bind
  sudo firewall-cmd --reload
  sudo firewall-cmd --list-all
}
```
 
### 2. Настройка клиента  

Установка пакетов необходимых для функционирования сервера  
`sudo yum install -y nfs-utils`  
 
Монтирование NFSv3 по UDP  
`sudo mount.nfs -vv 192.168.10.10:/export/shared /mnt -o nfsvers=3,proto=udp,soft`  
