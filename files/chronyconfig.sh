#!/bin/sh
ipnet=`echo $@ | awk '{print $1}'`
ipmask=`echo $@ | awk '{print $2}'`
/bin/cat /etc/chrony.conf | /bin/grep "$ipnet"
if [ $? -ne 0 ]; then
 echo server 0.pool.ntp.org iburst >> /etc/chrony.conf
 echo allow $ipnet/$ipmask >> /etc/chrony.conf
 systemctl enable chronyd.service
 systemctl start chronyd.service
fi
