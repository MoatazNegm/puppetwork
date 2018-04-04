#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
keyconf='/etc/keystone/keystone.conf';
httpd='/etc/httpd/conf/httpd.conf';
pass=`echo $@ | awk '{print $1}'`;
cont=`echo $@ | awk '{print $2}'`;
pcsg=`echo $@ | awk '{print $3}'`;
token=`openssl rand -hex 10`;
cat $keyconf | grep $pass &>/dev/null
if [ $? -ne 0 ]; then
 sed -i "/admin_token \=/c\admin_token \= $token" $keyconf
 sed -i "/provider \=/c\provider \= fernet" $keyconf
sed -i "/key\_repository \=/c\key\_repository \= \/${p}\/etc\/keystone\/fernet\-keys\/" $keyconf
 sed -i "/connection \=/c\connection \= mysql\+pymysql\:\/\/keystone\:$pass@$cont\/keystone" $keyconf
 su -s /bin/sh -c "keystone-manage db_sync" keystone;
 keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone;
 sed -i "/ServerName www/c\ServerName $cont"  $httpd
fi
pcsitems=`pcs resource`
echo $pcsitems | grep keyweb
if [ $? -ne 0 ]; then
 cp /root/server_status.conf /etc/httpd/conf.d/ ;
 pcs resource create keyweb ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf statusurl="http://127.0.0.1/server-status" op monitor interval=1min
 pcs resource group add ${pcsg}g keyweb
 pcs constraint order iscsizfs then keyweb
fi
