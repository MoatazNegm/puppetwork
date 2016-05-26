/* 
$CC = '10.11.11.98'
$compute1 = '10.11.11.97'
$block1 = '10.11.11.96'
$object1 = '10.11.11.95'
$compute2 = '10.11.11.94'
$block2 = '10.11.11.93'
$object2 = '10.11.11.92'
$net = '10.11.11.0'
$node1 = 'centoszfs1c'
$node2 = 'centoszfs2c'
$share = 'p1'
$mysql_pass = 'tmatem'
$rabbit_user = 'openstack'
$rabbit_pass = 'tmatem'

$keystonedb_pass = 'tmatem'
$defualtAdmin_pass = 'tmatem'
$defualtDemo_pass = 'tmatem'
$glancedb_pass = 'tmatem'
$glanceuser_pass = 'tmatem'

$computedb_pass = 'tmatem'
$computeuser_pass = 'tmatem'
  
$kvm = 'qemu'
*/
$neutronuser_pass = 'tmatem'
$neutrondb_pass = 'tmatem'
$ether = 'enp0s8'
$metadatasecret = 'tmatem'
class neutron {
       package { [ 'openstack-neutron', 'openstack-neutron-ml2', 'openstack-neutron-linuxbridge', 'ebtables' ]:
	ensure => 'installed',
	notify => 'dummyrun',
	}
	exec { 'dummyrun':
	command => "/bin/true",
	refreshonly => true,
	}
       file {  '/etc/neutron/metadata_agent.ini':
        mode => 755,
        source => 'puppet:///extra_files/metadata_agent.ini',
	ensure => 'file',
        subscribe => Exec['dummyrun'],
	}
       file {  '/etc/neutron/dhcp_agent.ini':
        mode => 755,
        source => 'puppet:///extra_files/dhcp_agent.ini',
	ensure => 'file',
        subscribe => Exec['dummyrun'],
	}
       file {  '/etc/neutron/l3_agent.ini':
        mode => 755,
        source => 'puppet:///extra_files/l3_agent.ini',
	ensure => 'file',
        subscribe => Exec['dummyrun'],
	}
       file {  '/etc/neutron/plugins/ml2/linuxbridge_agent.ini':
        mode => 755,
        source => 'puppet:///extra_files/linuxbridge_agent.ini',
	ensure => 'file',
        subscribe => Exec['dummyrun'],
	}
       file {  '/etc/neutron/plugins/ml2/ml2_conf.ini':
        mode => 755,
        source => 'puppet:///extra_files/ml2_conf.ini',
	ensure => 'file',
        subscribe => Exec['dummyrun'],
	}
       file {  '/etc/neutron/neutron.conf':
        mode => 755,
        source => 'puppet:///extra_files/neutron.conf',
	ensure => 'file',
        subscribe => Exec['dummyrun'],
	}
       file {  '/root/neutronch.sh':
        mode => 755,
        source => 'puppet:///extra_files/neutronch.sh',
	ensure => 'file',
	}
       file {  '/root/neutronch2.sh':
        mode => 755,
        source => 'puppet:///extra_files/neutronch2.sh',
	ensure => 'file',
        subscribe => Exec['dummyrun'],
	}
	exec { 'neutronch':
	cwd => '/root',
	command => "/bin/sh neutronch.sh $mysql_pass $CC $neutrondb_pass $neutronuser_pass $CC ",
	logoutput => true,
	subscribe => File['/root/neutronch.sh','/etc/neutron/metadata_agent.ini', '/etc/neutron/dhcp_agent.ini','/etc/neutron/l3_agent.ini','/etc/neutron/plugins/ml2/linuxbrindge_agent.ini','/etc/neutron/plugins/ml2/ml2_conf.ini','/etc/neutorn/neutron.conf'],
	}
	exec { 'neutronch2':
	cwd => '/root',
	command => "/bin/sh neutronch2.sh $CC $CC $neutronuser_pass $neutrondb_pass $rabbit_pass $ether $metadatasecret $computeuser_pass CC",
	logoutput => true,
	subscribe => [ File['/root/neutronch2.sh'], Exec['neutronch'] ],
	}
}
