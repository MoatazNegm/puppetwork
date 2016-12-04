#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
#node=`echo $@ | awk '{print $1}'`
node=`hostname -s`
systemctl start pcsd
systemctl enable pcsd 
secureha=$(expect -c "
set timeout 10
spawn passwd hacluster
expect \"New password:\"
send \"YousefNadody\r\"
expect \"Retype new passowrd:\"
send \"YousefNadody\r\"
expect eof
")
echo $secureha
authcluster=$(expect -c "
spawn pcs cluster auth $node
expect \"Username:\"
send \"hacluster\r\"
expect \"Password:\"
send \"YousefNadody\r\"
expect eof
")
pcs cluster setup --name ha_cluster $node
pcs cluster start --all
pcs cluster enable --all
pcs status cluster
pcs status corosync
