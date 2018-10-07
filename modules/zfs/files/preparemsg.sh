#!/bin/sh
export PATH=/root/elixir/bin:/bin:/usr/bin:/sbin:/usr/sbin:/root
#cd ~/elixir
#make clean test
#cp /root/elixir/bin/*  /usr/bin
cd ~/elixir
python3.6 -m pip install python-nmap-0.6.1.tar.gz
yum install -y rabbitmq-server-3.6.1-1.noarch.rpm
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
systemctl start rabbitmq-server
systemctl enable rabbitmq-server 
chown -R etcd /etc/etcd/*
/pace/startzfs.sh:/sbin/rabbitmqctl add_user rabbmezo HIHIHI 2>/dev/null
/pace/startzfs.sh:/sbin/rabbitmqctl set_permissions -p / rabbmezo ".*" ".*" ".*" 2>/dev/null
/pace/startzfs.sh:/sbin/rabbitmqctl set_user_tags rabbmezo administrator
