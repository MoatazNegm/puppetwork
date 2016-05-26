#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
novaconf='/etc/nova/nova.conf';
dbpass=`echo $@ | awk '{print $1}'`;
cont=`echo $@ | awk '{print $2}'`;
contip=`echo $@ | awk '{print $3}'`;
uspass=`echo $@ | awk '{print $4}'`;
CC=`echo $@ | awk '{print $5}'`;
rabbitpass=`echo $@ | awk '{print $6}'`;
cat $novaconf | grep $dbpass &>/dev/null
if [ $? -ne 0 ]; then
 cp nova.conf $novaconf;
 sed -i "s/DBPASS/${dbpass}/g" $novaconf 
 sed -i "s/USPASS/${uspass}/g" $novaconf
 sed -i "s/CC/$contip/g" $novaconf
 sed -i "s/COMPUTEIP/$contip/g" $novaconf
 sed -i "s/RABBITPASS/${rabbitpass}/g" $novaconf
 sed -i "s/\#NOVA\#//g" $novaconf
 chmod 640 $novaconf
 chown root:nova $novaconf
 su -s /bin/sh -c "nova-manage api_db sync" nova;
 su -s /bin/sh -c "nova-manage db sync" nova;
fi
pcsitems=`pcs resource`
echo $pcsitems | grep nova &>/dev/null
if [ $? -ne 0 ]; then
 pcs resource create novaapi ocf:heartbeat:novaapi op monitor interval=1min
 pcs resource create novaconsole ocf:heartbeat:novaconsole op monitor interval=1min
 pcs resource create novasched ocf:heartbeat:novasched op monitor interval=1min
 pcs resource create novacond ocf:heartbeat:novacond op monitor interval=1min
 pcs resource create novavnc ocf:heartbeat:novavnc op monitor interval=1min
 pcs resource group add ${cont}g novaapi
 pcs resource group add ${cont}g novaconsole
 pcs resource group add ${cont}g novasched
 pcs resource group add ${cont}g novacond
 pcs resource group add ${cont}g novavnc
 pcs constraint order glance then novaapi
 pcs constraint order glance then novaconsole
 pcs constraint order glance then novasched
 pcs constraint order glance then novacond
 pcs constraint order glance then novavnc
fi
