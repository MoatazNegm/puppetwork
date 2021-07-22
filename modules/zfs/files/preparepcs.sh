#!/bin/sh
echo $@ > /root/preparepcsparam
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
eth=`echo $@ | awk '{print $1}'`
netm=`echo $@ | awk '{print $2}'`
initip=`echo $@ | awk '{print $3}'`
node=`hostname -s`
#systemctl start pcsd
systemctl enable pcsd 
systemctl start pcsd 
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
echo "@reboot /TopStor/initcron.sh " > /root/cronfile
#echo "*/4 * * * *  sh /pace/iscsiwatchdog.sh" >> /root/cronfile
echo "5 8 * * 0  /TopStor/autoGenPatch" >> /root/cronfile
echo "*/5 * * * * /TopStor/ioperf.py Initialization" >> /root/cronfile
crontab /root/cronfile
#cd /TopStor/
#cp pcsd.service /usr/lib/systemd/system/
#cp target.service /usr/lib/systemd/system/
