#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
ls -lisah /  | grep pace
if [ $? -ne 0 ]; then
 mkdir /pace
 mkdir -p /pacedata/pools
 cd /pace
 git init
 git remote add origin https://github.com/MoatazNegm/HC.git
 git fetch
 git checkout -b openstack
 git pull origin openstack
fi
