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
