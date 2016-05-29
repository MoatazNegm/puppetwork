#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
mysqlpass=`echo $@ | awk '{print $1}'`;
CC=`echo $@ | awk '{print $2}'`;
pass=`echo $@ | awk '{print $3}'`;
pass2=`echo $@ | awk '{print $4}'`;
cont=`echo $@ | awk '{print $5}'`;
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
