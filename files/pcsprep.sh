#!/bin/sh
ipaddr=`echo $@ | /bin/awk '{print $1}'`
netm=`echo $@ | /bin/awk '{print $2}'`
node1=`echo $@ | /bin/awk '{print $3}'`
node2=`echo $@ | /bin/awk '{print $4}'`
man=`echo $@ | /bin/awk '{print $5}'`
/sbin/pcs resource create $man ocf:heartbeat:IPaddr2 ip=$ipaddr cidr_netmask=$netm op monitor interval=5s
/sbin/pcs resource group add ${man}g $man
/sbin/pcs constraint location ${man}g prefers $node1=100
/sbin/pcs constraint location ${man}g prefers $node2=10
