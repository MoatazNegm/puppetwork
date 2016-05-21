/* 
$CC = '192.168.0.98'
$compute1 = '192.168.0.97'
$block1 = '192.168.0.96'
$object1 = '192.168.0.95'
$compute2 = '192.168.0.94'
$block2 = '192.168.0.93'
$object2 = '192.168.0.92'
$net = '192.168.0.0'
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
	}
	exec { 'neutronch':
	cwd => '/root',
	command => "/bin/sh neutronch.sh $mysql_pass $CC $neutrondb_pass $neutronuser_pass $CC ",
	logoutput => true,
	subscribe => File['/root/neutronch.sh'],
	}
	exec { 'neutronch2':
	cwd => '/root',
	command => "/bin/sh neutronch2.sh $CC $CC $neutronuser_pass $neutrondb_pass $rabbit_pass $ether $metadatasecret $computeuser_pass CC",
	logoutput => true,
	subscribe => [ File['/root/neutronch2.sh'], Exec['neutronch'], Package[ 'openstack-neutron', 'openstack-neutron-ml2', 'openstack-neutron-linuxbridge', 'ebtables' ] ],
	}
}
