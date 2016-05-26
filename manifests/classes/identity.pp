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
*/
$keystonedb_pass = 'tmatem'
$defualtAdmin_pass = 'tmatem'
$defualtDemo_pass = 'tmatem'
$glancedb_pass = 'tmatem'
$glanceuser_pass = 'tmatem'
class identity {
        file { '/root/identitysql.sh':
        mode => 755,
        source => 'puppet:///extra_files/identitysql.sh',
	ensure => 'file',
	}
	exec { 'identityDB':
	cwd => '/root',
	command => "/bin/sh identitysql.sh $mysql_pass $CC $keystonedb_pass",
	subscribe => File['/root/identitysql.sh'],
	}
	package { [ 'openstack-keystone', 'httpd', 'mod_wsgi', 'openstack-glance' ]:
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
        file { '/root/server_status.conf':
        mode => 755,
        source => 'puppet:///extra_files/server_status.conf',
	ensure => 'file',
	subscribe => Package['httpd'],
	}
	exec { 'identitch':
	cwd => '/root',
	command => "/bin/sh idchanges.sh $keystonedb_pass $CC CC",
	subscribe => [ File['/root/idchanges.sh'], File['/root/server_status.conf'] ],
	}
        file { '/usr/lib/ocf/resource.d':
        mode => 755,
        source => 'puppet:///extra_files/resource.d',
	recurse => 'true',
	}
        file { '/root/keystonech.sh':
        mode => 755,
        source => 'puppet:///extra_files/keystonech.sh',
	ensure => 'file',
	subscribe => Exec['identitch'],
	}
	exec { 'keystonech':
	cwd => '/root',
	command => "/bin/sh keystonech.sh $CC",
	logoutput => true,
	subscribe => [ Exec['identitch'],File['/root/keystonech.sh'], File['/usr/lib/ocf/resource.d'] ],
	}
        file { '/root/keystonech2.sh':
        mode => 755,
        source => 'puppet:///extra_files/keystonech2.sh',
	ensure => 'file',
	}
	exec { 'keystonech2':
	cwd => '/root',
	command => "/bin/sh keystonech2.sh $defualtAdmin_pass $defualtDemo_pass $CC",
	logoutput => true,
	subscribe => [ File['/root/keystonech2.sh'], Exec['keystonech'] ],
	}
        file { '/root/glance-registry.conf':
        mode => 755,
        source => 'puppet:///extra_files/glance-registry.conf',
	ensure => 'file',
	}
        file { '/root/glance-api.conf':
        mode => 755,
        source => 'puppet:///extra_files/glance-api.conf',
	ensure => 'file',
	}
        file { '/root/glancech.sh':
        mode => 755,
        source => 'puppet:///extra_files/glancech.sh',
	ensure => 'file',
	}
	exec { 'glancech':
	cwd => '/root',
	command => "/bin/sh glancech.sh $mysql_pass $CC $glancedb_pass $glanceuser_pass",
	logoutput => true,
	subscribe => [ File['/root/glance-api.conf'], File['/root/glance-registry.conf'], File['/root/glancech.sh'], Exec['keystonech2'] ],
	}
        file { '/root/glancech2.sh':
        mode => 755,
        source => 'puppet:///extra_files/glancech2.sh',
	ensure => 'file',
	subscribe => Exec['identitch'],
	}
	exec { 'glancech2':
	cwd => '/root',
	command => "/bin/sh glancech2.sh $glancedb_pass CC $CC $glanceuser_pass $share || :",
	logoutput => true,
	subscribe => [ File['/root/glancech2.sh'], Exec['glancech'], File['/root/glance-api.conf'], File['/root/glance-registry.conf'], Package['openstack-glance'] ],
	}
}
