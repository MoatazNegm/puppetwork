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
sysctl -p
