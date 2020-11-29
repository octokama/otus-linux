#!/bin/bash


echo "Server"
sudo touch /etc/sysconfig/network-scripts/ifcfg-eth1
echo "NM_CONTROLLED=yes
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.10.10
NETMASK=255.255.255.0
DEVICE=eth1
PEERDNS=no" >> /etc/sysconfig/network-scripts/ifcfg-eth1

sudo yum install -y nfs-utils

sudo systemctl enable rpcbind
sudo systemctl enable nfs-server
sudo systemctl enable rpc-statd
sudo systemctl enable nfs-idmapd

sudo systemctl start rpcbind
sudo systemctl start nfs-server
sudo systemctl start rpc-statd
sudo systemctl start nfs-idmapd

sudo mkdir -p /export/shared
sudo chmod 0777 /export/shared

cat << EOF | sudo tee /etc/exports
/export/shared  192.168.10.0/24(rw,async)
EOF

sudo exportfs -ra
