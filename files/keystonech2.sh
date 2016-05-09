#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
pass=`echo $@ | awk '{print $1}'`;
source keystonesource
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
users=`openstack user list | wc -l`;
echo users = $users
if [ $users -lt 2 ]; then
 source keystonesource
 openstack domain create --description "Default Domain" default 
 openstack project create --domain default --description "Admin Project" admin 
 openstack user create --domain default  --password $pass admin 
fi
