#!/bin/sh
man=`echo $@ | /bin/awk '{print $1}'`;
export PATH=/bin:/sbin:/usr/bin:/usr/sbin:/root
resources=`/sbin/pcs resource `;
hostss=`/bin/cat /etc/hosts`;
