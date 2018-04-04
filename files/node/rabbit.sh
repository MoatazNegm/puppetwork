#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
user=`echo $@ | awk '{print $1}'`
pass=`echo $@ | awk '{print $2}'`
node=`echo $@ | awk '{print $3}'`
ip=`echo $@ | awk '{print $4}'`
pcsitems=`pcs resource`
#systemctl enable rabbitmq-server.service 
echo RABBITMQ_NODENAME=rabbitmq@$node > /etc/rabbitmq/rabbitmq-env.conf
echo RABBITMQ_NODE_IP_ADDRESS=$ip >> /etc/rabbitmq/rabbitmq-env.conf

systemctl start rabbitmq-server.service
while [ $i -ne 0 ]; do
 sleep 1
 i=$((i-1));
 systemctl status rabbitmq-server.service | grep running &>/dev/null 
 if [ $? -eq 0 ]; then  
  rabbitmqctl add_user $user  $pass -n rabbitmq@$node
  rabbitmqctl set_permissions $user ".*" ".*" ".*" -n rabbitmq@$node
  i=0
 fi
done
systemctl enable memcached.service 
systemctl start memcached.service
systemctl stop rabbitmq-server.service
