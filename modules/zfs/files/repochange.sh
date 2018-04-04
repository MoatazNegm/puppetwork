#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
mv /etc/yum.repos.d /etc/yum.repos.d.old
mkdir /etc/yum.repos.d
cp /root/localrepo.repo  /etc/yum.repos.d/
yum clean all
yum -y update
