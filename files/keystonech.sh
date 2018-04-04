#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
keyconf='/etc/keystone/keystone.conf';
cont=`echo $@ | awk '{print $1}'`;
token=`cat $keyconf | grep "admin_token =" | awk '{print $3}'`;
ls /root | grep keystonesource &>/dev/null
if [ $? -ne 0 ]; then
 echo export OS_TOKEN=$token > keystonesource
 echo export OS_URL=http://$cont:35357/v3 >> keystonesource
 echo export OS_IDENTITY_API_VERSION=3 >> keystonesource
 source keystonesource
 su -s /bin/sh -c "keystone-manage db_sync" keystone;
 keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone;
 openstack service create --name keystone --description "OpenStack Identity" identity 
 openstack endpoint create --region RegionOne identity public http://$cont:5000/v3
 openstack endpoint create --region RegionOne identity internal http://$cont:5000/v3
 openstack endpoint create --region RegionOne identity admin http://$cont:35357/v3
fi
