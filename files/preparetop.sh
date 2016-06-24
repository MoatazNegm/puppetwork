#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
mkdir /TopStor
cd /TopStor
git init
git remote add origin https://github.com/MoatazNegm/TopStordev.git
git checkout -b messages
git pull origin messages
