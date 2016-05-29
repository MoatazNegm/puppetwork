#!/bin/sh
ipaddr=`echo $@ | /bin/awk '{print $1}'`
netm=`echo $@ | /bin/awk '{print $2}'`
node1=`echo $@ | /bin/awk '{print $3}'`
node2=`echo $@ | /bin/awk '{print $4}'`
man=`echo $@ | /bin/awk '{print $5}'`;
eth=`echo $@ | /bin/awk '{print $6}'`
resources=`/sbin/pcs resource `;
hostss=`/bin/cat /etc/hosts`;
