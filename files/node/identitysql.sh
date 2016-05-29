#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
mysqlpass=`echo $@ | awk '{print $1}'`;
CC=`echo $@ | awk '{print $2}'`;
pass=`echo $@ | awk '{print $3}'`;
isDB=`echo "SHOW DATABASES;" | mysql -u root -p$mysqlpass`
echo $isDB | grep keystone &>/dev/null
if [ $? -ne 0 ]; then
 echo "CREATE DATABASE keystone;" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'localhost' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'%' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
 echo "GRANT ALL PRIVILEGES ON keystone.* TO 'keystone'@'$CC' IDENTIFIED BY '$pass';" | mysql -u root -p$mysqlpass
fi
