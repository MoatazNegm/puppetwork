#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
httpd='/etc/httpd/conf/httpd.conf';
man=`echo $@ | awk '{print $1}'`
node=`echo $@ | awk '{print $2}'`
manip=`echo $@ | awk '{print $3}'`
eth=`echo $@ | awk '{print $4}'`
netm=`echo $@ | awk '{print $5}'`
hostname=`hostname -s`
mkdir /var/www/html/des20 2>/dev/null
mkdir /TopStor 2>/dev/null
mkdir /TopStordata 2>/dev/null
pcsitems=`pcs resource`
cd /TopStor
 sed -i "/SELINUX\=/c\SELINUX\=disabled" /etc/selinux/config 
 setenforce 0
systemctl stop firewalld
systemctl disable firewalld
git status | grep \# | grep On | grep centos >/dev/null
if [ $? -ne 0 ]; then
 git init
# git remote add origin https://github.com/MoatazNegm/TopStordev.git
 git remote add origin http://localrepo/TopStordev.git
 git remote add origin2 http://github.com/MoatazNegm/TopStordev.git
 git fetch origin
 git checkout -b QS1.44 
 git pull origin QS1.44
 ln -s /bin/zsh /usr/local/bin/
 chown apache /TopStor/key -R
 echo $hostname > /TopStordata/hostname
fi
echo $pcsitems | grep TopStor >/dev/null
if [ $? -ne 0 ]; then
 pcs resource create TopStor ocf:heartbeat:TopStor op monitor interval=1s
 pcs resource group add ${man}g TopStor
fi
cd /var/www/html/des20
git status | grep \# | grep On | grep centos >/dev/null
if [ $? -ne 0 ]; then
 git init
# git remote add origin https://github.com/MoatazNegm/TopStorweb.git
 git remote add origin http://localrepo/TopStorweb.git
 git remote add origin2 http://github.com/MoatazNegm/TopStorweb.git
 git checkout -b QS1.44
 git pull origin QS1.44
 chown apache Data -R
fi

sed -i "s/HOSTY/$manip/g" /etc/httpd/conf.d/sshhttp.conf
echo "$pcsitems" | grep keyweb
if [ $? -ne 0 ]; then
 sed -i "/ServerName www/c\ServerName $node "  $httpd
 cp /root/server_status.conf /etc/httpd/conf.d/ ;
# pcs resource create keyweb ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf statusurl="http://127.0.0.1/server-status" op monitor interval=1min
 pcs resource create keyweb ocf:heartbeat:apache  op monitor interval=1min
 pcs resource group add ${man}g keyweb
fi
systemctl enable topstor.service
systemctl enable topstorremote.service
systemctl enable topstorremoteack.service
systemctl start topstor.service
systemctl start topstorremote.service
systemctl start topstorremoteack.service
systemctl enable pcsfix.service
systemctl start pcsfix.service
#systemctl enable smb.service
systemctl start smb.service
mkdir /var/nfsshare 2>/dev/null
chmod -R 777 /var/nfsshare/ 
systemctl enable rpcbind
systemctl enable nfs-server
systemctl enable nfs-idmap
systemctl enable nfs-lock
systemctl start rpcbind
systemctl start nfs-server
systemctl start nfs-idmap
systemctl start nfs-lockcd
cd /root/netdata
./netdata-installer.sh --dont-wait
