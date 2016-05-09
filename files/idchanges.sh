#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
keyconf='/etc/keystone/keystone.conf';
httpd='/etc/httpd/conf/httpd.conf';
pass=`echo $@ | awk '{print $1}'`;
cont=`echo $@ | awk '{print $2}'`;
token=`openssl rand -hex 10`;
cat $keyconf | grep $pass &>/dev/null
if [ $? -ne 0 ]; then
 sed -i "/admin_token \=/c\admin_token \= $token" $keyconf
 sed -i "/provider \=/c\provider \= fernet" $keyconf
 sed -i "/connection \=/c\connection \= mysql\+pymysql\:\/\/keystone\:$pass@$cont\/keystone" $keyconf
 su -s /bin/sh -c "keystone-manage db_sync" keystone;
 keystone-manage fernet_setup --keystone-user keystone --keystone-group keystone;
 sed -i "/ServerName www/c\ServerName $cont"  $httpd
fi
pcsitems=`pcs resource`
echo $pcsitems | grep keyweb
if [ $? -ne 0 ]; then
 pcs resource create keyweb ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf statusurl="http://CC/server-status" op monitor interval=1min
 pcs resource group add ${cont}g keyweb
 pcs constraint order iscsizfs then keyweb
fi

