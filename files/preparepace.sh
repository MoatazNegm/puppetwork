#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
mkdir /pace
mkdir /pacedata/
cd /pace
git init
git remote add origin https://github.com/MoatazNegm/HC.git
git fetch
git checkout -b openstack
git pull origin openstack

