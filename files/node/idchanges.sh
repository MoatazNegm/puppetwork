#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
keyconf='/etc/keystone/keystone.conf';
httpd='/etc/httpd/conf/httpd.conf';
pass=`echo $@ | awk '{print $1}'`;
cont=`echo $@ | awk '{print $2}'`;
pcsg=`echo $@ | awk '{print $3}'`;
p=`echo $@ | awk '{print $4}'`;
token=`openssl rand -hex 10`;
sed -i "/admin_token \=/c\admin_token \= $token" $keyconf
sed -i "/provider \=/c\provider \= fernet" $keyconf
sed -i "/key\_repository \=/c\key\_repository \= \/${p}\/etc\/keystone\/fernet\-keys\/" $keyconf
sed -i "/connection \=/c\connection \= mysql\+pymysql\:\/\/keystone\:$pass@$cont\/keystone" $keyconf
sed -i "/ServerName www/c\ServerName $cont"  $httpd
cp /root/server_status.conf /etc/httpd/conf.d/ ;
