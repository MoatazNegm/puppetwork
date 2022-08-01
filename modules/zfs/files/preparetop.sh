#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
echo $@ > /root/preparetopparam
httpd='/etc/httpd/conf/httpd.conf';
man=`echo $@ | awk '{print $1}'`
node=`echo $@ | awk '{print $2}'`
manip=`echo $@ | awk '{print $3}'`
eth=`echo $@ | awk '{print $4}'`
netm=`echo $@ | awk '{print $5}'`
hostname=`hostname -s`
mkdir /opt/passwds
ln /etc/passwd /opt/passwds/passwd
ln /etc/group /opt/passwds/group
ln /etc/shadow /opt/passwds/shadow

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
 git remote add origin http://10.11.11.124/TopStordev.git
 git remote add origin2 http://github.com/MoatazNegm/TopStordev.git
 git remote set-url --push origin2 https://github.com/MoatazNegm/TopStordev.git
 git fetch origin
 git checkout -b QS2.96
 git pull origin QS2.96
 ln -s /bin/zsh /usr/local/bin/
 chown apache /TopStor/key -R
 echo $hostname > /TopStordata/hostname
fi
echo $pcsitems | grep TopStor >/dev/null
if [ $? -ne 0 ]; then
 pcs resource create TopStor ocf:heartbeat:TopStor op monitor interval=1s on-fail=restart
 pcs resource group add ${man}g TopStor
fi
cd /var/www/html/des20
git status | grep \# | grep On | grep centos >/dev/null
if [ $? -ne 0 ]; then
 git init
# git remote add origin https://github.com/MoatazNegm/TopStorweb.git
 git remote add origin http://10.11.11.124/TopStorweb.git
 git remote add origin2 http://github.com/MoatazNegm/TopStorweb.git
 git remote set-url --push origin2 https://github.com/MoatazNegm/TopStorweb.git
 git checkout -b QS2.96
 git pull origin QS2.96
 rm -rf dashboarddev2/img/*
 rm -rf dashboarddev2/dist/img/*
 #cp img/* dashboarddev2/img/
# cp img/* dashboarddev2/dist/img/
# rm -rf dashboarddev2/plugins/fontawesome-free/*
# cp -r plugins/fontawesome-free/* dashboarddev2/plugins/fontawesome-free/
# rm -rf dashboarddev2/plugins/gfont/*
# cp -r plugins/gfont/* dashboarddev2/plugins/gfont/
 
 mkdir Data
 chown apache Data -R
 chown apache Data -R
fi
rm -rf /etc/httpd/conf.d/sshhttp.conf
cp /TopStor/sshhttp.conf /etc/httpd/conf.d/
sed -i "s/HOSTY/$manip/g" /etc/httpd/conf.d/sshhttp.conf
echo "$pcsitems" | grep keyweb
if [ $? -ne 0 ]; then
 sed -i "/ServerName www/c\ServerName $node "  $httpd
 cp /root/server_status.conf /etc/httpd/conf.d/ ;
# pcs resource create keyweb ocf:heartbeat:apache configfile=/etc/httpd/conf/httpd.conf statusurl="http://127.0.0.1/server-status" op monitor interval=1min
 pcs resource create keyweb ocf:heartbeat:apache  op monitor interval=1min on-fail=restart
 pcs resource group add ${man}g keyweb
fi
systemctl enable topstor.service
systemctl enable zfsping.service
#systemctl enable topstorremote.service
#systemctl enable topstorremoteack.service
systemctl enable target 
systemctl enable iscsi 
systemctl enable iscsid 
systemctl enable pcsfix.service
#systemctl enable smb.service
mkdir /var/nfsshare 2>/dev/null
chmod -R 777 /var/nfsshare/ 
systemctl enable rpcbind
systemctl disable nfs-server
systemctl disable nfs-idmap
systemctl disable nfs-lock
cd /root/netdata
systemctl status netdata 2>/dev/null
if [ $? -ne 0 ];
then
# ./netdata-installer.sh --dont-wait
sleep 1

fi
gpg --list-public-keys
rm -rf /root/.gnupg/trustdb.gpg
cp /TopStor/key/trustdb.gpg /root/.gnupg/
rm -rf /root/.gnupg/secring.gpg
cp /TopStor/key/secring.gpg /root/.gnupg/
rm -rf /root/.gnupg/pubring.gpg
cp /TopStor/key/pubring.gpg /root/.gnupg/
rm -rf /TopStor/key/adminfixed.gpg
cp /TopStor/factory/adminfixed.gpg /TopStor/key/
cd /TopStor/
#cp pcsd.service /usr/lib/systemd/system/
cp target.service /usr/lib/systemd/system/
echo 10.11.11.60 > /pacedata/clusterip
cp /TopStor/grafana.files /TopStordata -r
cp /TopStor/grafana /TopStordata -r
cp /TopStor/prometheus.files /TopStordata -r
cp /TopStordata/prometheus.files/orig_prometheus.yml.orig /TopStordata/prometheus.files/prometheus.yml.orig
sed -i "s/HOSTNAME/$hostname/g" /TopStordata/prometheus.files/prometheus.yml.orig
sed -i "s/HOSTNAME/$hostname/g" /TopStordata/grafana/provisioning/datasources/datasource.yaml
cp /TopStordata/prometheus.files/prometheus.yml.orig /TopStordata/prometheus.files/prometheus.yml
echo $manip $hostname >> /TopStordata/grafana.files/hosts
echo $manip $hostname >> /TopStordata/prometheus.files/hosts
rm -rf /root/.git*
cp /root/elixir2/.git* /root/
git config --global credential.helper store
systemctl disable nfs
systemctl disable rpc-statd
systemctl disable smb
