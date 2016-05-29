#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
pass=`echo $@ | awk '{print $1}'`;
pass2=`echo $@ | awk '{print $2}'`;
cont=`echo $@ | awk '{print $3}'`;
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
echo export OS_PROJECT_DOMAIN_NAME=default > admin-openrc
echo export OS_USER_DOMAIN_NAME=default >> admin-openrc
echo export OS_PROJECT_NAME=admin >> admin-openrc
echo export OS_USERNAME=admin >> admin-openrc
echo export OS_PASSWORD=$pass >> admin-openrc
echo export OS_AUTH_URL=http://$cont:35357/v3 >> admin-openrc
echo export OS_IDENTITY_API_VERSION=3 >> admin-openrc
echo export OS_IMAGE_API_VERSION=2 >> admin-openrc

echo export OS_PROJECT_DOMAIN_NAME=default > demo-openrc
echo export OS_USER_DOMAIN_NAME=default >> demo-openrc
echo export OS_PROJECT_NAME=demo >> demo-openrc
echo export OS_USERNAME=demo >> demo-openrc
echo export OS_PASSWORD=$pass2 >> demo-openrc
echo export OS_AUTH_URL=http://$cont:5000/v3 >> demo-openrc
echo export OS_IDENTITY_API_VERSION=3 >> demo-openrc
echo export OS_IMAGE_API_VERSION=2 >> demo-openrc
