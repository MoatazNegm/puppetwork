#!/bin/sh
ipaddr=`echo $@ | /bin/awk '{print $1}'`
netm=`echo $@ | /bin/awk '{print $2}'`
node1=`echo $@ | /bin/awk '{print $3}'`
node2=`echo $@ | /bin/awk '{print $4}'`
man=`echo $@ | /bin/awk '{print $5}'`;
eth=`echo $@ | /bin/awk '{print $6}'`
resources=`/sbin/pcs resource `;
hostss=`/bin/cat /etc/hosts`;
echo $resources | /bin/grep -v ${man}g | /bin/grep $man &>/dev/null
if [ $? -ne 0 ]; then
 /sbin/pcs resource create $man ocf:heartbeat:IPaddr2 ip=$ipaddr nic=$eth cidr_netmask=$netm op monitor interval=5s
 /sbin/pcs resource group add ${man}g $man
# /sbin/pcs constraint location ${man}g prefers $node1=100
# /sbin/pcs constraint location ${man}g prefers $node2=10
fi
echo $hostss | /bin/grep $man &>/dev/null
if [ $? -ne 0 ]; then
 echo $ipaddr $man ${man}.local.com >> /etc/hosts
fi
/sbin/pcs property set start-failure-is-fatal=false
/sbin/pcs resource defaults resource-stickiness=100
/sbin/pcs resource meta ${man}g resource-stickiness=100
