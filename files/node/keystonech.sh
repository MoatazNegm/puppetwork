#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
keyconf='/etc/keystone/keystone.conf';
cont=`echo $@ | awk '{print $1}'`;
token=`cat $keyconf | grep "admin_token =" | awk '{print $3}'`;
echo export OS_TOKEN=$token > keystonesource
echo export OS_URL=http://$cont:35357/v3 >> keystonesource
echo export OS_IDENTITY_API_VERSION=3 >> keystonesource
