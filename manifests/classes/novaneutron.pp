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

$neutronuser_pass = 'tmatem'
$neutrondb_pass = 'tmatem'
$ether = 'enp0s8'
$metadatasecret = 'tmatem'
*/
class novaneutron {
       package { [ 'openstack-neutron-linuxbridge', 'ebtables', 'ipset' ]:
	ensure => 'installed',
	}
       file {  '/root/novaneutronch2.sh':
        mode => 755,
        source => 'puppet:///extra_files/novaneutronch2.sh',
	ensure => 'file',
	}
	exec { 'novaneutronch2':
	cwd => '/root',
	command => "/bin/sh novaneutronch2.sh CC $compute1 $neutronuser_pass $neutrondb_pass $rabbit_pass $ether $metadatasecret",
	logoutput => true,
	subscribe => [ File['/root/novaneutronch2.sh'], Package['openstack-neutron-linuxbridge'], Package['ebtables'], Package['ipset'] ],
	}
}
