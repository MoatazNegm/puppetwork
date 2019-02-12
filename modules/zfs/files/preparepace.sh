#!/bin/sh
echo $@ >/root/preparepaceparam
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
hostname=`hostname -s`
#hostip=`host $hostname | awk '{print $4}'`
hostip='127.0.0.1'
ls -lisah /  | grep pace
if [ $? -ne 0 ]; then
 mkdir /pace
 mkdir -p /pacedata/pools
 cd /pace
 git init
# git remote add origin https://github.com/MoatazNegm/HC.git
 git remote add origin http://10.11.11.124/HC.git
 git remote add origin2 http://github.com/MoatazNegm/HC.git
 git fetch origin
 git checkout -b QS2.70
 git pull origin QS2.70
 echo $hostip $hostname > /pacedata/iscsitargets
 echo $hostip $hostname > /pace/iscsitargets
fi
 echo $hostip $hostname >> /etc/hosts

