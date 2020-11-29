#!/bin/bash

# set -eux
echo "Client"

sudo touch /etc/sysconfig/network-scripts/ifcfg-eth1
echo "NM_CONTROLLED=yes
BOOTPROTO=none
ONBOOT=yes
IPADDR=192.168.10.11
NETMASK=255.255.255.0
DEVICE=eth1
PEERDNS=no" >> /etc/sysconfig/network-scripts/ifcfg-eth1

sudo ip addr add 192.168.10.11/24 dev eth1

sudo yum install -y nfs-utils

echo "Mount NFSv3 UDP"
sudo mkdir /mnt
# sudo mount.nfs -vv 192.168.10.10:/export/shared /mnt -o nfsvers=3,proto=udp,soft
sudo echo "192.168.10.10:/export/shared /mnt       nfs     nfsvers=3,proto=udp,soft        0 0" >> /etc/fstab
# sudo umount /mnt
sudo mount /mnt
