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
*/
class nodecompute1 {
        file {  '/usr/lib/ocf/resource.d':
        mode => 755,
        source => 'puppet:///extra_files/resource.d',
	recurse => 'true',
	}
        file {  '/root/nova.conf':
        mode => 755,
        source => 'puppet:///extra_files/node/nova.conf',
	ensure => 'file',
	}
        file {  '/root/computech.sh':
        mode => 755,
        source => 'puppet:///extra_files/node/computech.sh',
	ensure => 'file',
	}
	exec { 'computech':
	cwd => '/root',
	command => "/bin/sh computech.sh $mysql_pass $CC $computedb_pass $computeuser_pass CC",
	logoutput => true,
	subscribe => File['/root/computech.sh'],
	}
	package { [ 'openstack-nova-api', 'openstack-nova-conductor', 'openstack-nova-console', 'openstack-nova-novncproxy', 'openstack-nova-scheduler' ]:
	ensure => 'installed',
	}
	file { '/root/computech2.sh':
	mode => 755,
	source => 'puppet:///extra_files/node/computech2.sh',
	ensure => 'file',
	}
	exec { 'computech2':
	cwd => '/root',
	command => "/bin/sh computech2.sh $computedb_pass CC $CC $computeuser_pass CC $rabbit_pass",
	subscribe => [ Exec['computech'], File['/root/computech2.sh'], File['/root/nova.conf'], Package[ 'openstack-nova-api', 'openstack-nova-conductor', 'openstack-nova-console', 'openstack-nova-novncproxy', 'openstack-nova-scheduler'] ],
	}
}
