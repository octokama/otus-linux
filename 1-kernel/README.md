Основная часть сделана по https://github.com/octokama/manual_kernel_update
## \*Сборка ядра из исходников:
### 1) Установка необходимых пакетов для компиляции ядра:
`sudo yum update`  
`sudo yum install -y ncurses-devel make gcc bc bison flex elfutils-libelf-devel openssl-devel grub2`  
`sudo reboot`  

### 2) Компиляция и установка ядра ​​в CentOS 7
`cd /usr/src/`  
`sudo wget https://cdn.kernel.org/pub/linux/kernel/v4.x/linux-4.17.11.tar.xz`  
`sudo tar -xvf linux-4.17.11.tar.xz`  
  
`cd linux-4.17.11/`  
`sudo cp -v /boot/config-3.10.0-1127.el7.x86_64 /usr/src/linux-4.17.11/.config`  
  
`cd /usr/src/linux-4.17.11/`  
`sudo make menuconfig`  
  
`sudo make bzImage`  
`sudo make modules`  
`sudo make`  
`sudo make install`  
`sudo make modules_install`  
  
`uname -r`  

## \*\*Настройка VirtualBox Shared Folders:

### 1) Добавить в vagrantfile строчку: 
`config.vm.synced_folder ".", "/vagrant", type: "virtualbox"`  
### 2) Перед `vagrant up` нужно установить плагин:
`vagrant plugin install vagrant-vbguest`  
и запустить его `vagrant vbguest`
### 3) touch /vagrant/tmp.txt
