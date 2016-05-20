#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
novaconf='/etc/nova/nova.conf';
cont=`echo $@ | awk '{print $1}'`;
contip=`echo $@ | awk '{print $2}'`;
uspass=`echo $@ | awk '{print $3}'`;
CC=`echo $@ | awk '{print $4}'`;
rabbitpass=`echo $@ | awk '{print $5}'`;
kvm=`echo $@ | awk '{print $6}'`;
cat $novaconf | grep $contip &>/dev/null
if [ $? -ne 0 ]; then
 sed -i "0,/my_ip/s//MY_IP/g" $novaconf 
 sed -i "/MY_IP/c\my_ip \= ${contip}" $novaconf
 sed -i "/rpc_backend \=/c\rpc_backend \= rabbit" $novaconf
 sed -i "/rpc_backend\=/c\rpc_backend \= rabbit" $novaconf
 sed -i "/rabbit_host \=/c\rabbit_host \= $CC" $novaconf
 sed -i "/rabbit_host\=/c\rabbit_host \= $CC" $novaconf
 sed -i "/rabbit_userid \=/c\rabbit_userid \= openstack" $novaconf
 sed -i "/rabbit_userid\=/c\rabbit_userid \= openstack" $novaconf
 sed -i "/rabbit_password \=/c\rabbit_password \= $rabbitpass" $novaconf
 sed -i "/rabbit_password\=/c\rabbit_password \= $rabbitpass" $novaconf
 sed -i "/auth_strategy \=/c\auth_strategy \= keystone" $novaconf
 sed -i "/auth_strategy\=/c\auth_strategy \= keystone" $novaconf
 sed -i "/auth_uri \=/c\auth_uri \= http://$CC:5000" $novaconf
 sed -i "/auth_uri\=/c\auth_uri \= http://$CC:5000" $novaconf
 sed -i "/auth_uri \=/a auth_url \= http://$CC:35357" $novaconf
 sed -i "/auth_url \= http/a memcached_servers \= $CC\:11211" $novaconf
 sed -i "/memcached_servers \= $CC/a auth_type \= password" $novaconf
 sed -i "/auth_type \= password/a project_domain_name \= default" $novaconf
 sed -i "/project_domain_name \= default/a user_domain_name \= default" $novaconf
 sed -i "/user_domain_name \= default/a project_name \= service" $novaconf
 sed -i "/project_name \= service/a username \= nova" $novaconf
 sed -i "/username \= nova/a password \= $uspass" $novaconf
 sed -i "/use_neutron \=/c\use_neutron \= True" $novaconf
 sed -i "/use_neutron\=/c\use_neutron \= True" $novaconf
 sed -i "/firewall_driver \=/c\firewall_driver \= nova.virt.firewall.NoopFirewallDriver" $novaconf
 sed -i "/firewall_driver\=/c\firewall_driver \= nova.virt.firewall.NoopFirewallDriver" $novaconf
 sed -i "/\[vnc\]/a enabled \= True" $novaconf
 sed -i "/vncserver_listen \=/c\vncserver_listen \= 0.0.0.0" $novaconf
 sed -i "/vncserver_listen\=/c\vncserver_listen \= 0.0.0.0" $novaconf
 sed -i "/vncserver_proxyclient_address \=/c\vncserver_proxyclient_address \= $contip" $novaconf
 sed -i "/vncserver_proxyclient_address\=/c\vncserver_proxyclient_address \= $contip" $novaconf
 sed -i "/novncproxy_base_url \=/c\novncproxy_base_url \= http://$CC:6080/vnc_auto.html" $novaconf
 sed -i "/novncproxy_base_url\=/c\novncproxy_base_url \= http://$CC:6080/vnc_auto.html" $novaconf
 sed -i "/api_servers \=/c\api_servers \= http://$CC:9292" $novaconf
 sed -i "/api_servers\=/c\api_servers \= http://$CC:9292" $novaconf
 sed -i "/lock_path \=/c\lock_path \= /var/lib/nova/tmp" $novaconf
 sed -i "/lock_path\=/c\lock_path \= /var/lib/nova/tmp" $novaconf
 sed -i "/\[libvirt\]/a virt_type \= $kvm" $novaconf
fi
systemctl enable libvirtd.service openstack-nova-compute.service
systemctl start libvirtd.service openstack-nova-compute.service
