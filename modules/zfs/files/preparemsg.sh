#!/bin/sh
export PATH=/root/elixir/bin:/bin:/usr/bin:/sbin:/usr/sbin:/root
#cd ~/elixir
#make clean test
#cp /root/elixir/bin/*  /usr/bin
cd ~/elixir
python3.6 -m pip install python-nmap-0.6.1.tar.gz
python3.6 -m pip install Flask-2.0.0.tar.gz
python3.6 -m pip install prometheus_client-0.6.0.tar.gz
yum install -y rabbitmq-server
chown -R rabbitmq:rabbitmq /var/lib/rabbitmq/
systemctl start rabbitmq-server
systemctl enable rabbitmq-server 
chown -R etcd /etc/etcd/*
/sbin/rabbitmqctl add_user rabbmezo HIHIHI 2>/dev/null
/sbin/rabbitmqctl set_permissions -p / rabbmezo ".*" ".*" ".*" 2>/dev/null
/sbin/rabbitmqctl set_user_tags rabbmezo administrator
