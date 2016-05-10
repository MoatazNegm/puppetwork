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
*/
$computedb_pass = 'tmatem'
$computeuser_pass = 'tmatem'
class compute1 {
        file {  '/root/nova.conf':
        mode => 755,
        source => 'puppet:///extra_files/nova.conf',
	ensure => 'file',
	}
        file {  '/root/computech.sh':
        mode => 755,
        source => 'puppet:///extra_files/computech.sh',
	ensure => 'file',
	}
	exec { 'computech':
	cwd => '/root',
	command => "/bin/sh computech.sh $mysql_pass CC $computedb_pass $computeuser_pass CC",
	logoutput => true,
	subscribe => File['/root/computech.sh'],
	}
	package { [ 'openstack-nova-api', 'openstack-nova-conductor', 'openstack-nova-console', 'openstack-nova-novncproxy', 'openstack-nova-scheduler' ]:
	ensure => 'installed',
	}
	file { '/root/computech2.sh':
	mode => 755,
	source => 'puppet:///extra_files/computech2.sh',
	ensure => 'file',
	}
	exec { 'computech2':
	cwd => '/root',
	command => "/bin/sh computech2.sh $computedb_pass CC $CC $computeuser_pass CC $rabbit_pass",
	subscribe => [ Exec['computech'], File['/root/computech2.sh'], File['/root/nova.conf'], Package[ 'openstack-nova-api', 'openstack-nova-conductor', 'openstack-nova-console', 'openstack-nova-novncproxy', 'openstack-nova-scheduler'] ],
	}
}
