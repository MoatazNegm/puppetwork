#!/bin/sh
man=`echo $@ | /bin/awk '{print $1}'`;
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/root
resources=`/sbin/pcs resource `;
hostss=`/bin/cat /etc/hosts`;
echo $resources | /bin/grep ZFS &>/dev/null
if [ $? -ne 0 ]; then
 /bin/sh /pace/addtargetdisks.sh
 /bin/sh /pace/initdisks.sh
 /bin/sh /pace/listingtargets.sh
 /sbin/pcs resource create ZFS_cluster ocf:heartbeat:ZFS op monitor interval=5s on-fail=ignore
 i=100;
 didit=0
 while [ $i -ne 0 ]; do 
  sleep 1;
  i=$((i-1));
  /sbin/pcs resource | grep ZFS | grep Started 
  if [ $? -eq 0 ]; then
   i=0;
   didit=1;
   /sbin/pcs resource create iscsizfs ocf:heartbeat:zfsping op monitor interval=5s
   /sbin/pcs resource group add ${man}g ZFS_cluster 
   /sbin/pcs resource group add ${man}g iscsizfs 
  fi
 done
 if [ $didit -eq 0 ]; then exit 1; fi
fi
