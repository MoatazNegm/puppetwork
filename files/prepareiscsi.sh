#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
node=`echo $@ | awk '{print $1}'`
systemctl enable target
echo InitiatorName=iqn.1994-05.com.redhat:$node > /etc/iscsi/initiatorname.iscsi
/pace/iscsienable.sh
/pace/iscsirefresh.sh
/pace/listingtargets.sh
rm -rf /root/.ssh/*
ssh-keygen -t rsa -f /root/.ssh/id_rsa -q -P ""
securessh=$(expect -c "
 set timeout 10
 spawn ssh-copy-id root@$node 
 expect \"*\?\"
send \"yes\r\"
expect \"*assowrd:\"
send \"YousefNadody\r\"
expect eof
")
#/pace/initdisks.sh
