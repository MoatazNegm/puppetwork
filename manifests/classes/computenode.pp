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
*/  
$kvm = 'qemu'
class computenode {
	package { 'openstack-nova-compute':
	ensure => 'installed',
	}
        file {  '/root/computenodech.sh':
        mode => 755,
        source => 'puppet:///extra_files/computenodech.sh',
	ensure => 'file',
	}
	exec { 'computenodech':
	cwd => '/root',
	command => "/bin/sh computenodech.sh compute1 $compute1 $computeuser_pass CC $rabbit_pass $kvm",
	logoutput => true,
	subscribe => [ File['/root/computenodech.sh'], Package['openstack-nova-compute'] ],
	}
}
