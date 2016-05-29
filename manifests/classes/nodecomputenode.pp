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
class nodecomputenode {
	package { 'openstack-nova-compute':
	ensure => 'installed',
	}
        file {  '/root/computenodech.sh':
        mode => 755,
        source => 'puppet:///extra_files/node/computenodech.sh',
	ensure => 'file',
	}
	exec { 'computenodech':
	cwd => '/root',
	command => "/bin/sh computenodech.sh $CC $computeuser_pass $CC $rabbit_pass $kvm",
	logoutput => true,
	subscribe => [ File['/root/computenodech.sh'], Package['openstack-nova-compute'] ],
	}
}
