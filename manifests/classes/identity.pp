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
*/
$keystonedb_pass = 'tmatem'
class identity {
        file { '/root/identitysql.sh':
        mode => 755,
        source => 'puppet:///extra_files/identitysql.sh',
	ensure => 'file',
	}
	exec { 'identityDB':
	cwd => '/root',
	command => "/bin/sh identitysql.sh $mysql_pass CC $keystonedb_pass",
	subscribe => File['/root/identitysql.sh'],
	}
	package { [ 'openstack-keystone', 'httpd', 'mod_wsgi' ]:
	ensure => 'installed',
	}	
        file { '/etc/httpd/conf.d/wsgi-keystone.conf':
        mode => 755,
        source => 'puppet:///extra_files/wsgi-keystone.conf',
	ensure => 'file',
	subscribe => Package['httpd'],
	}
        file { '/root/idchanges.sh':
        mode => 755,
        source => 'puppet:///extra_files/idchanges.sh',
	ensure => 'file',
	subscribe => Package['openstack-keystone'],
	}
	exec { 'identitch':
	cwd => '/root',
	command => "/bin/sh idchanges.sh $keystonedb_pass CC",
	subscribe => File['/root/idchanges.sh'],
	}
}
