#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
mysqlpass=`echo $@ | awk '{print $1}'`;
CC=`echo $@ | awk '{print $2}'`;
pass=`echo $@ | awk '{print $3}'`;
pass2=`echo $@ | awk '{print $4}'`;
cont=`echo $@ | awk '{print $5}'`;
echo $@ > /root/tmp
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
isDB=`ssh $cont echo "SHOW DATABASES;" | mysql -u root -p$mysqlpass`
echo $isDB | grep neutron &>/dev/null
if [ $? -ne 0 ]; then
ssh $cont /bin/sh << EOF
 echo "CREATE DATABASE neutron;" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'localhost' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON neutron.* TO 'neutron'@'%' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
EOF
fi
source admin-openrc;
ls /root | grep neutrondone 
if [ $? -ne 0 ]; then
 touch /root/neutrondone
 openstack user create --domain default --password $pass2 neutron 
 openstack role add --project service --user neutron admin
 openstack service create --name neutron --description "OpenStack Networking" network 
 openstack endpoint create --region RegionOne network public http://$CC:9696
 openstack endpoint create --region RegionOne network internal http://$CC:9696
 openstack endpoint create --region RegionOne network admin http://$CC:9696
fi
