#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
mysqlpass=`echo $@ | awk '{print $1}'`;
CC=`echo $@ | awk '{print $2}'`;
pass=`echo $@ | awk '{print $3}'`;
pass2=`echo $@ | awk '{print $4}'`;
isDB=`echo "SHOW DATABASES;" | mysql -u root -p$mysqlpass`
echo $isDB | grep glance &>/dev/null
if [ $? -ne 0 ]; then
 echo "CREATE DATABASE glance;" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'localhost' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'%' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON glance.* TO 'glance'@'$CC' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
fi
source admin-openrc;
ls /root | grep glancedone 
if [ $? -ne 0 ]; then
 touch /root/glancedone
 openstack user create --domain default --password $pass2 glance
 openstack role add --project service --user glance admin
 openstack service create --name glance --description "OpenStack Image" image
 openstack endpoint create --region RegionOne image public http://$CC:9292
 openstack endpoint create --region RegionOne image internal http://$CC:9292
 openstack endpoint create --region RegionOne image admin http://$CC:9292
fi
