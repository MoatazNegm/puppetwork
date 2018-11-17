#!/bin/sh
echo $@ > /root/chronyconfigparam
ipnet=`echo $@ | awk '{print $1}'`
ipmask=`echo $@ | awk '{print $2}'`
cc=`echo $@ | awk '{print $3}'`
/bin/cat /etc/chrony.conf | /bin/grep "$ipnet"
if [ $? -ne 0 ]; then
 echo server 0.pool.ntp.org iburst >> /etc/chrony.conf
 echo server $cc iburst >> /etc/chrony.conf
 echo allow $ipnet/$ipmask >> /etc/chrony.conf
 systemctl disable ntpd
 systemctl enable chronyd.service
 systemctl start chronyd.service
fi
/bin/timedatectl set-timezone Africa/Cairo
