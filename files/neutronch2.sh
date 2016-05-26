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
 sed -i "s/CC/$contip/g" $neutronconf
 sed -i "s/NEUTDBPASS/$dbpass/g" $neutronconf
 sed -i "s/RABBITPASS/$rabbitpass/g" $neutronconf
 sed -i "s/NEUTPASS/$uspass/g" $neutronconf
 sed -i "s/NOVAPASS/$novauspass/g" $neutronconf
 sed -i "s/\#NEUTRON\#//g" $neutronconf
 sed -i "s/ETHER/$ether/g" $bridgeconf
 sed -i "s/CC/$contip/g" $bridgeconf

 sed -i "s/CC/$contip/g" $metadataconf
 sed -i "s/SECRET/$secret/g" $metadataconf

 sed -i "s/CC/$contip/g" $novaconf
 sed -i "s/SECRET/$secret/g" $novaconf
 sed -i "s/NEUTPASS/$uspass/g" $novaconf
 sed -i "s/\#NEUTRON\#//g" $novaconf
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
 pcs resource create neutron-l3-agent ocf:heartbeat:neutronl3 op monitor interval=1min
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
