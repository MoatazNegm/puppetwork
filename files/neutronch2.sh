#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
neutronconf='/etc/neutron/neutron.conf';
metadataconf='/etc/neutron/metadata_agent.ini';
novaconf='/etc/nova/nova.conf';
ml2conf='/etc/neutron/plugins/ml2/ml2_conf.ini';
l3conf='/etc/neutron/l3_agent.ini';
dhcpconf='/etc/neutron/dhcp_agent.ini';
bridgeconf='/etc/neutron/plugins/ml2/linuxbridge_agent.ini';
cont=`echo $@ | awk '{print $1}'`;
contip=`echo $@ | awk '{print $2}'`;
uspass=`echo $@ | awk '{print $3}'`;
dbpass=`echo $@ | awk '{print $4}'`;
rabbitpass=`echo $@ | awk '{print $5}'`;
ether=`echo $@ | awk '{print $6}'`;
secret=`echo $@ | awk '{print $7}'`;
novauspass=`echo $@ | awk '{print $8}'`;
pcsg=`echo $@ | awk '{print $9}'`;
echo $@ > neturontmp
cat $neutronconf | grep $contip &>/dev/null
if [ $? -ne 0 ]; then
 sed -i "/bind_host \=/c\bind_host \= $contip" $neutronconf
 sed -i "/bind_host\=/c\bind_host \= $contip" $neutronconf
 sed -i "/\[database\]/a connection \= mysql+pymysql://neutron:$dbpass@$cont/neutron" $neutronconf
 sed -i "/core_plugin \=/c\core_plugin \= ml2" $neutronconf
 sed -i "/core_plugin\=/c\core_plugin \= ml2" $neutronconf
 sed -i "/service_plugins \=/c\service_plugins \= router" $neutronconf
 sed -i "/service_plugins\=/c\service_plugins \= router" $neutronconf
 sed -i "/allow_overlapping_ips \=/c\allow_overlapping_ips \= True" $neutronconf
 sed -i "/allow_overlapping_ips\=/c\allow_overlapping_ips \= True" $neutronconf
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
 sed -i "/notify_nova_on_port_status_changes \=/c\notify_nova_on_port_status_changes \= True" $neutronconf
 sed -i "/notify_nova_on_port_status_changes\=/c\notify_nova_on_port_status_changes \= True" $neutronconf
 sed -i "/notify_nova_on_port_data_changes \=/c\notify_nova_on_port_data_changes \= True" $neutronconf
 sed -i "/notify_nova_on_port_data_changes\=/c\notify_nova_on_port_data_changes \= True" $neutronconf
 sed -i "/\[nova\]/a password \= $novauspass" $neutronconf
 sed -i "/\[nova\]/a username \= nova" $neutronconf
 sed -i "/\[nova\]/a project_name \= service" $neutronconf
 sed -i "/\[nova\]/a region_name \= RegionOne" $neutronconf
 sed -i "/\[nova\]/a user_domain_name \= default" $neutronconf
 sed -i "/\[nova\]/a project_domain_name \= default" $neutronconf
 sed -i "/\[nova\]/a auth_type \= password" $neutronconf
 sed -i "/\[nova\]/a auth_url \= http://$cont:35357" $neutronconf
 sed -i "/\[oslo_concurrency\]/a lock_path \= /var/lib/neutron/tmp" $neutronconf
 sed -i "/\[ml2\]/a type_drivers \= flat,vlan,vxlan" $ml2conf
 sed -i "/\[ml2\]/a tenant_network_types \= vxlan" $ml2conf
 sed -i "/\[ml2\]/a mechanism_drivers \= linuxbridge,l2population" $ml2conf
 sed -i "/\[ml2\]/a extension_drivers \= port_security" $ml2conf
 sed -i "/\[ml2_type_flat\]/a flat_networks \= provider" $ml2conf
 sed -i "/\[ml2_type_vxlan\]/a vni_ranges \= 1:1000" $ml2conf
 sed -i "/\[securitygroup\]/a enable_ipset \= True" $ml2conf
 sed -i "/\[linux_bridge\]/a physical_interface_mappings \= provider:$ether" $bridgeconf
 sed -i "/\[vxlan\]/a enable_vxlan \= True" $bridgeconf
 sed -i "/\[vxlan\]/a local_ip \= $contip" $bridgeconf
 sed -i "/\[vxlan\]/a l2_population \= True" $bridgeconf
 sed -i "/\[securitygroup\]/a enable_security_group \= True" $bridgeconf
 sed -i "/\[securitygroup\]/a firewall_driver \= neutron.agent.linux.iptables_firewall.IptablesFirewallDriver" $bridgeconf
 sed -i "/\[DEFAULT\]/a interface_driver \= neutron.agent.linux.interface.BridgeInterfaceDriver" $l3conf
 sed -i "/\[DEFAULT\]/a external_network_bridge \=" $l3conf
 sed -i "/\[DEFAULT\]/a interface_driver \= neutron.agent.linux.interface.BridgeInterfaceDriver" $dhcpconf
 sed -i "/\[DEFAULT\]/a dhcp_driver \= neutron.agent.linux.dhcp.Dnsmasq" $dhcpconf
 sed -i "/\[DEFAULT\]/a enable_isolated_metadata \= True" $dhcpconf

 sed -i "/\[DEFAULT\]/a nova_metadata_ip \= $cont" $metadataconf
 sed -i "/\[DEFAULT\]/a metadata_proxy_shared_secret \= $secret" $metadataconf

 sed -i "/\[neutron\]/a service_metadata_proxy \= True" $novaconf
 sed -i "/\[DEFAULT\]/a metadata_proxy_shared_secret \= $secret" $novaconf
 sed -i "/\[neutron\]/a password \= $uspass" $novaconf
 sed -i "/\[neutron\]/a username \= neutron" $novaconf
 sed -i "/\[neutron\]/a project_name \= service" $novaconf
 sed -i "/\[neutron\]/a region_name \= RegionOne" $novaconf
 sed -i "/\[neutron\]/a user_domain_name \= default" $novaconf
 sed -i "/\[neutron\]/a project_domain_name \= default" $novaconf
 sed -i "/\[neutron\]/a auth_type \= password" $novaconf
 sed -i "/\[neutron\]/a auth_url \= http://$cont:35357" $novaconf
 ln -s $ml2conf /etc/neutron/plugin.ini
 su -s /bin/sh -c "neutron-db-manage --config-file /etc/neutron/neutron.conf --config-file /etc/neutron/plugins/ml2/ml2_conf.ini upgrade head" neutron
 systemctl restart openstack-nova-api.service
fi
pcsitems=`pcs resource`
echo $pcsitems | grep neutron &>/dev/null
if [ $? -ne 0 ];then
 pcs resource create neutron-server ocf:heartbeat:neutronserver op monitor interval=1min
 pcs resource create neutron-linuxbridge ocf:heartbeat:neutronlinuxbridge op monitor interval=1min
 pcs resource create neutron-dhcp ocf:heartbeat:neutrondhcp op monitor interval=1min
 pcs resource create neutron-metadata ocf:heartbeat:neutronmetadata op monitor interval=1min
 pcs resource create neutron-l3-agent ocf:heartbeat:neutronl3agent op monitor interval=1min
 pcs resource group add ${pcsg}g neutron-server
 pcs resource group add ${pcsg}g neutron-linuxbridge
 pcs resource group add ${pcsg}g neutron-dhcp
 pcs resource group add ${pcsg}g neutron-metadata
 pcs resource group add ${pcsg}g neutron-l3-agent
 pcs constraint order novaapi then neutron-server
 pcs constraint order novaapi then neutron-linuxbridge
 pcs constraint order novaapi then neutron-dhcp
 pcs constraint order novaapi then neutron-metadata
 pcs constraint order novaapi then neutron-l3-agent
fi
