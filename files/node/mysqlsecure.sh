#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
mysqlpass=`echo $@ | awk '{print $1}'`;
