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

$neutronuser_pass = 'tmatem'
$neutrondb_pass = 'tmatem'
$ether = 'enp0s8'
$metadatasecret = 'tmatem'
*/
class dashboard {
       file {  '/root/local_settings':
        mode => 755,
        source => 'puppet:///extra_files/local_settings',
	ensure => 'file',
	}
       file {  '/root/dashboardch.sh':
        mode => 755,
        source => 'puppet:///extra_files/dashboardch.sh',
	ensure => 'file',
	}
       package { [ 'openstack-dashboard' ]:
	ensure => 'installed',
	}
	exec { 'dashboardch.sh':
	cwd => '/root',
	command => "/bin/sh dashboardch.sh $CC ",
	subscribe => [ Package['openstack-dashboard'], File ['/root/local_settings'], File['/root/dashboardch.sh'] ] ,
	}
}
