#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
cont=`echo $@ | awk '{print $1}'`
p=`echo $@ | awk '{print $2}'`
node=`echo $@ | awk '{print $3}'`
mongo='/etc/mongod.conf'
sed -i "/bind_ip \=/c\bind_ip \= $cont" $mongo
cat $mongo | grep $p &>/dev/null
if [ $? -ne 0 ]; then
 sed -i "s/\/var\//\/${p}\/var\//g" $mongo
fi
myhost=`hostname`;
pcsg=`pcs resource`;
echo $pcsg | grep mongo_${myhost}
if [ $? -ne 0 ]; then
 pcs resource create mongo_${myhost} ocf:heartbeat:mongodb
 pcs constraint order iscsizfs then mongo_${myhost}
 pcs resource group add ${myhost}g mongo_$myhost
fi
#systemctl enable mongod.service
#systemctl start mongod.service
