#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
cont=`echo $@ | awk '{print $1}'`
p=`echo $@ | awk '{print $2}'`
mongo='/etc/mongod.conf'
sed -i "/bind_ip \=/c\bind_ip \= $cont" $mongo
cat $mongo | grep $p &>/dev/null
if [ $? -ne 0 ]; then
 sed -i "s/\/var\//\/${p}\/var\//g" $mongo
fi
mkdir -p /${p}/var/{lib/mongodb,run/mongodb,log/mongodb}
#systemctl enable mongod.service
#systemctl start mongod.service
