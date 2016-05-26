#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
novaconf='/etc/nova/nova.conf';
cont=`echo $@ | awk '{print $1}'`;
contip=`echo $@ | awk '{print $2}'`;
uspass=`echo $@ | awk '{print $3}'`;
CC=`echo $@ | awk '{print $4}'`;
rabbitpass=`echo $@ | awk '{print $5}'`;
kvm=`echo $@ | awk '{print $6}'`;
cat $novaconf | grep $contip &>/dev/null
if [ $? -ne 0 ]; then
 sed -i "s/\$my\_ip/0\.0\.0\.0/g" $novaconf
 sed -i "s/COMPUTEIP/${contip}/g" $novaconf
 sed -i "s/CC/$CC/g" $novaconf
 sed -i "s/RABBITPASS/$rabbitpass/g" $novaconf
 sed -i "s/USPASS/$uspass/g" $novaconf
 sed -i "s/KVM/$kvm/g" $novaconf
 sed -i "s/\#COMPUTE\#//g" $novaconf
fi
systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service
