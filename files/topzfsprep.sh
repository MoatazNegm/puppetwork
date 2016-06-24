#!/bin/sh
man=`echo $@ | /bin/awk '{print $1}'`;
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/root
resources=`/sbin/pcs resource `;
hostss=`/bin/cat /etc/hosts`;
echo $resources | /bin/grep zfsping &>/dev/null
if [ $? -ne 0 ]; then
/pace/ZFSstart.sh
echo \/paec\/ZFSstart.sh >> /etc/rc.local
   /sbin/pcs resource create iscsizfs ocf:heartbeat:zfsping op monitor interval=5s
   /sbin/pcs resource group add ${man}g iscsizfs 
fi
