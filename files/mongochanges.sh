#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
cont=`echo $@ | awk '{print $1}'`
p=`echo $@ | awk '{print $2}'`
node=`echo $@ | awk '{print $3}'`
mongo='/etc/mongod.conf'
pcs=`pcs resource`;
echo $pcs | grep mongo &>/dev/null
if [ $? -ne 0 ]; then
 sed -i "/bind_ip \=/c\bind_ip \= $cont" $mongo
 cat $mongo | grep $p &>/dev/null
 if [ $? -ne 0 ]; then
  sed -i "s/\/var\//\/${p}\/var\//g" $mongo
 fi
 mkdir -p /${p}/var/{lib/mongodb,run/mongodb,log/mongodb} &>/dev/null
 chown mongodb /${p}/var/{lib/mongodb,run/mongodb,log/mongodb}
 pcs resource create mongo ocf:heartbeat:mongodb
 pcs constraint order iscsizfs then mongo
 pcs resource group add ${node}g mongo
fi
#systemctl enable mongod.service
#systemctl start mongod.service
