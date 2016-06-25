#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
httpd='/etc/httpd/conf/httpd.conf';
man=`echo $@ | awk '{print $1}'`
node=`echo $@ | awk '{print $2}'`
manip=`echo $@ | awk '{print $3}'`
eth=`echo $@ | awk '{print $4}'`
netm=`echo $@ | awk '{print $5}'`
mkdir /var/www/html/des20 2>/dev/null
mkdir /TopStor 2>/dev/null
mkdir /TopStordata 2>/dev/null
pcsitems=`pcs resource`
cd /TopStor
git status | grep \# | grep On | grep centos >/dev/null
if [ $? -ne 0 ]; then
 git init
 git remote add origin https://github.com/MoatazNegm/TopStordev.git
 git checkout -b centos
 git pull origin centos
 ln -s /bin/zsh /usr/local/bin/
 chown apache /Topstor/key -R
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
 git remote add origin https://github.com/MoatazNegm/TopStorweb.git
 git checkout -b centos
 git pull origin centos
 chown apache Data -R
fi

echo $pcsitems | grep keyweb
if [ $? -ne 0 ]; then
 sed -i "/ServerName www/c\ServerName $node "  $httpd
 sed -i "s/HOST/$manip/g" /etc/httpd/conf.d/sshhttp.conf
 cp /root/server_status.conf /etc/httpd/conf.d/ ;
 pcs resource create keyweb ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf statusurl="http://127.0.0.1/server-status" op monitor interval=1min
 pcs resource group add ${man}g keyweb
fi
systemctl enable topstor.service
systemctl start topstor.service
systemctl enable pcsfix.service
systemctl start pcsfix.service
systemctl enable smb.service
systemctl start smb.service
