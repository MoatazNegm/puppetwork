#!/bin/sh
export PATH==/bin:/sbin:/usr/bin:/usr/sbin:/root
cc=`echo $@ | awk '{print $1}'`
p=`echo $@ | awk '{print $2}'`
man=`echo $@ | awk '{print $3}'`
mariaserver='/etc/my.cnf.d/mariadb-server.cnf'
fileis='/etc/my.cnf.d/openstack.cnf'
echo "[mysqld]" > $fileis
echo bind-address = $cc >> $fileis
echo default-storage-engine = innodb >> $fileis
echo innodb_file_per_table >> $fileis
echo collation-server = utf8_general_ci >> $fileis
echo character-set-server = utf8 >> $fileis
cat $mariaserver | grep "${p}" &>/dev/null
if [ $? -ne 0 ]; then 
 sed -i "s/\/var\//\/${p}\/var\//g" $mariaserver
fi
mkdir -p /${p}/var/{lib/mysql,log/mariadb,run/mariadb} &>/dev/null
chown mysql /${p}/var/{lib/mysql,log/mariadb,run/mariadb} &>/dev/null
rm -rf /var/{lib/mysql,log/mariadb,run/mariadb} &>/dev/null
ln -s  /${p}/var/lib/mysql /var/lib/mysql
ln -s  /${p}/var/log/mariadb /var/log/mariadb
ln -s  /${p}/var/run/mariadb /var/run/mariadb
mysql_install_db --user=mysql
pcs resource create mariadb${man} ocf:heartbeat:mysql datadir=/${p}/var/lib/mysql op monitor interval=3s
groupitems=`/sbin/pcs resource show ${man}g`;
echo $groupitems | grep ZFS &>/dev/null
if [ $? -ne 0 ]; then
 pcs resource group add ${man}g ZFS_cluster 
fi
echo $groupitems | grep iscsizfs &>/dev/null
if [ $? -ne 0 ]; then
 pcs resource group add ${man}g iscsizfs 
fi
echo $groupitems | grep mariadb &>/dev/null
if [ $? -ne 0 ]; then
 pcs resource group add ${man}g mariadb${man} 
fi
groupitems=`pcs constraint order`;
echo $groupitems | grep ZFS &>/dev/null
if [ $? -ne 0 ]; then
 pcs constraint order ZFS_cluster then iscsizfs
 pcs constraint order iscsizfs then mariadb${man};
fi
#systemctl enable mariadb.service
#systemctl start mariadb.service
