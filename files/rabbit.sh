#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
user=`echo $@ | awk '{print $1}'`
pass=`echo $@ | awk '{print $2}'`
node=`echo $@ | awk '{print $3}'`
ip=`echo $@ | awk '{print $4}'`
pcsitems=`pcs resource`
echo $pcsitems | grep rabbit
if [ $? -ne 0 ]; then
 echo RABBITMQ_NODENAME=rabbitmq@$node > /etc/rabbitmq/rabbitmq-env.conf
 echo RABBITMQ_NODE_IP_ADDRESS=$ip >> /etc/rabbitmq/rabbitmq-env.conf
 pcs resource create rabbitserver ocf:heartbeat:rabbitmq op monitor interval=3s
 pcs constraint order iscsizfs then rabbitserver
 pcs resource group add ${node}g rabbitserver
#systemctl enable rabbitmq-server.service 
#systemctl start rabbitmq-server.service
i=1000000
while [ $i -ne 0 ]; do
 i=$((i-1));
 pcs resource | grep rabbitserver | grep Started
 if [ $? -eq 0 ]; then  
  rabbitmqctl add_user $user  $pass -n rabbitmq@$node
  rabbitmqctl set_permissions $user ".*" ".*" ".*" -n rabbitmq@$node
  i=0
 fi
done
systemctl enable memcached.service 
systemctl start memcached.service
fi


