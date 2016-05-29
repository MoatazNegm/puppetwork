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
pcsitems=`pcs resource`
