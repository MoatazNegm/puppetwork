#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
user=`echo $@ | awk '{print $1}'`
pass=`echo $@ | awk '{print $2}'`
systemctl enable rabbitmq-server.service 
systemctl start rabbitmq-server.service
rabbitmqctl add_user $user  $pass
rabbitmqctl set_permissions $user ".*" ".*" ".*"


