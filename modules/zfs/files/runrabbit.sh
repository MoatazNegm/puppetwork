#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
/pace/startzfs.sh:/sbin/rabbitmqctl add_user rabbmezo HIHIHI 2>/dev/null
/pace/startzfs.sh:/sbin/rabbitmqctl set_permissions -p / rabbmezo ".*" ".*" ".*" 2>/dev/null
/pace/startzfs.sh:/sbin/rabbitmqctl set_user_tags rabbmezo administrator
