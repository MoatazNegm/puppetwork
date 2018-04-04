#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
novaconf='/etc/nova/nova.conf';
dbpass=`echo $@ | awk '{print $1}'`;
cont=`echo $@ | awk '{print $2}'`;
contip=`echo $@ | awk '{print $3}'`;
uspass=`echo $@ | awk '{print $4}'`;
CC=`echo $@ | awk '{print $5}'`;
rabbitpass=`echo $@ | awk '{print $6}'`;
cp nova.conf $novaconf;
sed -i "s/DBPASS/${dbpass}/g" $novaconf 
sed -i "s/USPASS/${uspass}/g" $novaconf
sed -i "s/CC/$contip/g" $novaconf
sed -i "s/COMPUTEIP/$contip/g" $novaconf
sed -i "s/RABBITPASS/${rabbitpass}/g" $novaconf
sed -i "s/\#NOVA\#//g" $novaconf
chmod 640 $novaconf
chown root:nova $novaconf
