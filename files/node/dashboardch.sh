#!/bin/sh/
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
dashconf='/etc/openstack-dashboard/local_settings';
CC=`echo $@ | awk '{print $1}'`;
cp local_settings $dashconf
sed -i "s/CC/$CC/g" $dashconf;
