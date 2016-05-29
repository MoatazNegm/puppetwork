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
echo $isDB | grep nova &>/dev/null
if [ $? -ne 0 ]; then
ssh $cont /bin/sh << EOF
 echo "CREATE DATABASE nova_api;" | mysql -u root -p$mysqlpass
 echo "CREATE DATABASE nova;" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'localhost' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'localhost' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON nova_api.* TO 'nova'@'%' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON nova.* TO 'nova'@'%' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
EOF
fi
source admin-openrc;
ls /root | grep novadone 
if [ $? -ne 0 ]; then
 touch /root/novadone
 openstack user create --domain default --password $pass2 nova
 openstack role add --project service --user nova admin
 openstack service create --name nova --description "OpenStack Compute" compute
 openstack endpoint create --region RegionOne compute public http://$CC:8774/v2.1/%\(tenant_id\)s
 openstack endpoint create --region RegionOne compute internal http://$CC:8774/v2.1/%\(tenant_id\)s
 openstack endpoint create --region RegionOne compute admin http://$CC:8774/v2.1/%\(tenant_id\)s
fi
