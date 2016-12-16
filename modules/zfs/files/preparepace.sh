#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
hostname=`hostname -s`
hostip=`host $hostname | awk '{print $4}'`
ls -lisah /  | grep pace
if [ $? -ne 0 ]; then
 mkdir /pace
 mkdir -p /pacedata/pools
 cd /pace
 git init
 git remote add origin https://github.com/MoatazNegm/HC.git
 git fetch origin
 git checkout -b openstack
 git pull origin openstack
 echo $hostip $hostname > /pacedata/iscsitargets
 echo $hostip $hostname > /pace/iscsitargets
fi
 echo $hostip $hostname >> /etc/hosts
