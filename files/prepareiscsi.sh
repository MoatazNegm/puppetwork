#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
systemctl enable target
echo InitiatorName=iqn.1994-05.com.redhat:labtop > /etc/iscsi/initiatorname.iscsi
