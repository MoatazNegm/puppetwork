#!/bin/sh
export PATH==/bin:/sbin:/usr/bin:/usr/sbin:/root
cc=`echo $@ | awk '{print $1}'`
p=`echo $@ | awk '{print $2}'`
mariaserver='/etc/my.cnf.d/mariadb-server.cnf'
fileis='/etc/my.cnf.d/openstack.cnf'
echo "[mysqld]" > $fileis
echo bind-address = $@ >> $fileis
echo default-storage-engine = innodb >> $fileis
echo innodb_file_per_table >> $fileis
echo collation-server = utf8_general_ci >> $fileis
echo character-set-server = utf8 >> $fileis
cat $mariaserver | grep "${p}" &>/dev/null
if [ $? -ne 0 ]; then 
 sed -i "s/\/var\//\/${p}\/var\//g" $mariaserver
fi
mkdir -p /${p}/var/{lib/mysql,log/mariadb,run/mariadb} &>/dev/null
systemctl enable mariadb.service
systemctl start mariadb.service
