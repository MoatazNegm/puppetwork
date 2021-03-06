#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
eth=`echo $@ | awk '{print $1}'`
netm=`echo $@ | awk '{print $2}'`
initip=`echo $@ | awk '{print $3}'`
#node=`hostname -s`
node='localhost'
systemctl start pcsd
systemctl enable pcsd 
secureha=$(expect -c "
set timeout 10
spawn passwd hacluster
expect \"New password:\"
send \"Abdoadmin\r\"
expect \"Retype new passowrd:\"
send \"Abdoadmin\r\"
expect eof
")
echo $secureha
authcluster=$(expect -c "
spawn pcs cluster auth $node
expect \"Username:\"
send \"hacluster\r\"
expect \"Password:\"
send \"Abdoadmin\r\"
expect eof
")
pcs cluster setup --name ha_cluster $node
pcs cluster start --all
pcs cluster enable --all
pcs status cluster
pcs status corosync
echo "@reboot sleep 120 && /sbin/pcs resource delete --force IPinit && /sbin/ip addr del ${initip}/${netm} dev $eth && /TopStor/factory.sh" > /root/cronfile
crontab /root/cronfile

