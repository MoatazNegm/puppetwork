#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
neutronconf='/etc/neutron/neutron.conf';
novaconf='/etc/nova/nova.conf';
ml2conf='/etc/neutron/plugins/ml2/ml2_conf.ini';
l3conf='/etc/neutron/l3_agent.ini';
dhcpconf='/etc/neutron/dhcp_agent.ini';
bridgeconf='/etc/neutron/plugins/ml2/linuxbridge_agent.ini';
cont=`echo $@ | awk '{print $1}'`;
nodeip=`echo $@ | awk '{print $2}'`;
uspass=`echo $@ | awk '{print $3}'`;
dbpass=`echo $@ | awk '{print $4}'`;
rabbitpass=`echo $@ | awk '{print $5}'`;
ether=`echo $@ | awk '{print $6}'`;
secret=`echo $@ | awk '{print $7}'`;
echo $@ > neturontmp
cat $neutronconf | grep $contip &>/dev/null
if [ $? -ne 0 ]; then
 sed -i "/\[database\] \=/a connection \= http://neutron:$dbpass@$cont/neutron" $neutronconf
 sed -i "/rpc_backend\=/c\rpc_backend \= rabbit" $neutronconf
 sed -i "/rpc_backend \=/c\rpc_backend \= rabbit" $neutronconf
 sed -i "/rabbit_host \=/c\rabbit_host \= $cont" $neutronconf
 sed -i "/rabbit_host\=/c\rabbit_host \= $cont" $neutronconf
 sed -i "/rabbit_userid \=/c\rabbit_userid \= openstack" $neutronconf
 sed -i "/rabbit_userid\=/c\rabbit_userid \= openstack" $neutronconf
 sed -i "/rabbit_password \=/c\rabbit_password \= $rabbitpass" $neutronconf
 sed -i "/rabbit_password\=/c\rabbit_password \= $rabbitpass" $neutronconf
 sed -i "/auth_strategy \=/c\auth_strategy \= keystone" $neutronconf
 sed -i "/auth_strategy\=/c\auth_strategy \= keystone" $neutronconf
 sed -i "/auth_uri \=/c\auth_uri \= http://$cont:5000" $neutronconf
 sed -i "/auth_uri\=/c\auth_uri \= http://$cont:5000" $neutronconf
 sed -i "/auth_uri \=/a auth_url \= http://$cont:35357" $neutronconf
 sed -i "/auth_url \= http/a memcached_servers \= $cont\:11211" $neutronconf
 sed -i "/memcached_servers \= $cont/a auth_type \= password" $neutronconf
 sed -i "/auth_type \= password/a project_domain_name \= default" $neutronconf
 sed -i "/project_domain_name \= default/a user_domain_name \= default" $neutronconf
 sed -i "/user_domain_name \= default/a project_name \= service" $neutronconf
 sed -i "/project_name \= service/a username \= neutron" $neutronconf
 sed -i "/username \= neutron/a password \= $uspass" $neutronconf
 sed -i "/\[oslo_concurrency\]/a lock_path \= /var/lib/neutron/tmp" $neutronconf
 sed -i "/\[linux_bridge\]/a physical_interface_mappings \= provider:$ether" $bridgeconf
 sed -i "/\[vxlan\]/a enable_vxlan \= True" $bridgeconf
 sed -i "/\[vxlan\]/a local_ip \= $nodeip" $bridgeconf
 sed -i "/\[vxlan\]/a l2_population \= True" $bridgeconf
 sed -i "/\[securitygroup\]/a enable_security_group \= True" $bridgeconf
 sed -i "/\[securitygroup\]/a firewall_driver \= neutron.agent.linux.iptables_firewall.IptablesFirewallDriver" $bridgeconf
 sed -i "/\[neutron\]/a password \= $uspass" $novaconf
 sed -i "/\[neutron\]/a username \= neutron" $novaconf
 sed -i "/\[neutron\]/a project_name \= service" $novaconf
 sed -i "/\[neutron\]/a region_name \= RegionOne" $novaconf
 sed -i "/\[neutron\]/a user_domain_name \= default" $novaconf
 sed -i "/\[neutron\]/a project_domain_name \= default" $novaconf
 sed -i "/\[neutron\]/a auth_type \= password" $novaconf
 sed -i "/\[neutron\]/a auth_url \= http://$cont:35357" $novaconf
 sed -i "/\[neutron\]/a url \= http://$cont:9696" $novaconf
 systemctl restart openstack-nova-compute.service
fi
iscontroller=`pcs resource`
echo $iscontroller | grep neutron
if [ $? -ne 0 ]; then 
 systemctl enable neutron-linuxbridge-agent.service
 systemctl start neutron-linuxbridge-agent.service
fi
