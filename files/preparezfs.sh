#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
rpm -ivh http://linux.dell.com/dkms/permalink/dkms-2.2.0.3-1.noarch.rpm
#yum localinstall --nogpgcheck http://epel.mirror.net.in/epel/7/x86_64/e/epel-release-7-5.noarch.rpm
yum localinstall -y --nogpgcheck http://archive.zfsonlinux.org/epel/zfs-release$(rpm -E %dist).noarch.rpm
gpg --quite --with-fingerprint /etc/pki/rpm-gpg/RPM-GPG-KEY-zfsonlinux
yum install -y epel-release
yum install -y kernel-devel-$(uname -r)  kernel-headers-$(uname -r)
yum install -y zfs
lsmod | grep zfs
if [ $? -ne 0 ]; then 
 modprobe zfs
 if [ $? -ne 0 ]; then
  dkms install spl/0.6.5.7
  dkms install zfs/0.6.5.7
  modprobe zfs
 fi
fi
cat /etc/rc.local | grep iscsienable 
if [ $? -ne 0 ]; then
 echo /sbin/zpool export -a >> /etc/rc.local
 echo rm -rf /var/lib/iscsi/send_targets/* >> /etc/rc.local
 echo rm -rf /var/lib/iscsi/nodes/* >> /etc/rc.local
 echo sh /pace/iscsienable.sh >> /etc/rc.local
 chmod 774 /etc/rc.local
 touch /pacedata/iscsitargets
fi
modprobe zfs
