#!/bin/sh
man=`echo $@ | /bin/awk '{print $1}'`;
manip=`echo $@ | /bin/awk '{print $2}'`;
eth=`echo $@ | /bin/awk '{print $3}'`;
netm=`echo $@ | /bin/awk '{print $4}'`;
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/root
resources=`/sbin/pcs resource `;
hostss=`/bin/cat /etc/hosts`;
echo $resources | /bin/grep zfsping &>/dev/null
if [ $? -ne 0 ]; then
 /pace/ZFSstart.sh
 echo \/paec\/ZFSstart.sh >> /etc/rc.local
 /sbin/pcs resource create $man ocf:heartbeat:IPaddr2 ip=$manip nic=$eth cidr_netmask=$netm op monitor interval=5s
 /sbin/pcs resource group add ${man}g $man 
 /sbin/pcs resource create iscsizfs ocf:heartbeat:zfsping op monitor interval=5s
 /sbin/pcs resource group add ${man}g iscsizfs 
fi
