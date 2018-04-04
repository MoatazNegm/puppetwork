#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
glanceapi='/etc/glance/glance-api.conf';
glancereg='/etc/glance/glance-registry.conf';
httpd='/etc/httpd/conf/httpd.conf';
dbpass=`echo $@ | awk '{print $1}'`;
cont=`echo $@ | awk '{print $2}'`;
contip=`echo $@ | awk '{print $3}'`;
uspass=`echo $@ | awk '{print $4}'`;
p=`echo $@ | awk '{print $5}'`;
cat $glanceapi | grep $dbpass &>/dev/null
if [ $? -ne 0 ]; then
 cp glance-api.conf $glanceapi;
 cp glance-registry.conf $glancereg;
 sed -i "s/CONTIP/${contip}/g" $glanceapi
 sed -i "s/CONTIP/${contip}/g" $glancereg 
 sed -i "s/CONT/${contip}/g" $glancereg 
 sed -i "s/CONT/${contip}/g" $glanceapi
 sed -i "s/DBPASS/${dbpass}/g" $glancereg 
 sed -i "s/DBPASS/${dbpass}/g" $glanceapi
 sed -i "s/USPASS/${uspass}/g" $glancereg 
 sed -i "s/USPASS/${uspass}/g" $glanceapi
 sed -i "s/SHARE/${p}/g" $glanceapi
 chmod 640 $glanceapi
 chmod 640 $glancereg
 chown root:glance $glancereg
 chown root:glance $glanceapi
 mkdir -p /${p}/var/lib/glance/images
 chown glance /${p}/var/lib/glance/images
 su -s /bin/sh -c "glance-manage db_sync" glance;
fi
pcsitems=`pcs resource`
echo $pcsitems | grep glance &>/dev/null
if [ $? -ne 0 ]; then
 pcs resource create glance ocf:heartbeat:glance op monitor interval=1min
 pcs resource group add ${cont}g glance
 pcs constraint order mariadb${cont} then glance
fi
echo $pcsitems | grep glancereg &>/dev/null
if [ $? -ne 0 ]; then
 pcs resource create glancereg ocf:heartbeat:glancereg op monitor interval=1min
 pcs resource group add ${cont}g glancereg
 pcs constraint order mariadb${cont} then glancereg
fi
