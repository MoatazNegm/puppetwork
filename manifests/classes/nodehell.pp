class hell {
        file { '/usr/lib/ocf/resource.d':
        mode => 755,
        source => 'puppet:///extra_files/node/resource.d',
	recurse => 'true',
	}
        file { '/root/pcsprep.sh':
        mode => 755,
        source => 'puppet:///extra_files/node/pcsprep.sh',
	ensure => 'file',
	subscribe => File['/usr/lib/ocf/resource.d'],
	}
	exec { 'pcsprep':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh $CC 24 $node2 $node1 CC enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File['/root/pcsprep.sh'],
	}
        file { '/root/zfsprep.sh':
        mode => 755,
        source => 'puppet:///extra_files/node/zfsprep.sh',
	ensure => 'file',
	}
	exec { 'zfsprep':
	cwd => '/root',
	command => "/bin/sh zfsprep.sh CC ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File['/root/zfsprep.sh'],
	}
	package { 'chrony':
	ensure => 'installed',
	subscribe => File["/root/pcsprep.sh"],
	}
        file { '/root/chronyconfig.sh':
        mode => 755,
        source => 'puppet:///extra_files/node/chronyconfig.sh',
	ensure => 'file',
	}
	exec { 'chronymore1':
	cwd => '/root',
	command => "/bin/sh chronyconfig.sh $net 24 CC",
	subscribe => [ Package[chrony], File['/root/chronyconfig.sh'] ]
	}
	package { 'centos-release-openstack-mitaka':
	ensure => 'installed',
	}
	package { 'expect':
	ensure => 'installed',
	}
	exec { 'repoinstall':
	cwd => '/root',
	command => "/bin/true",
	subscribe => [ Exec['zfsprep'], Exec['pcsprep'], Package["centos-release-openstack-mitaka"] ],
	}
	package { 'python-openstackclient':
	ensure => 'installed',
	}
	package { 'openstack-selinux':
	ensure => 'installed',
	}
	package { 'mariadb':
	ensure => 'installed',
	}
	package { 'mariadb-server':
	ensure => 'installed',
	}
	package { 'python2-PyMySQL':
	ensure => 'installed',
	}
        file { '/root/openstackcnf.sh':
        mode => 755,
        source => 'puppet:///extra_files/node/openstackcnf.sh',
	ensure => 'file',
        subscribe => Package["mariadb"],
	}
	exec { 'openstackcnf':
	cwd => '/root',
	command => "/bin/sh openstackcnf.sh $CC $share CC",
	subscribe => [ File['/root/openstackcnf.sh'], Exec['zfsprep'], Exec['pcsprep'] ], 
	}
        file { '/root/mysqlsecure.sh':
        mode => 755,
        source => 'puppet:///extra_files/node/mysqlsecure.sh',
	ensure => 'file',
        subscribe => Package["mariadb"],
	}
	exec { 'mysqlsecure':
	cwd => '/root',
	command => "/bin/sh mysqlsecure.sh $mysql_pass",
	subscribe => [ File['/root/mysqlsecure.sh'], Exec['openstackcnf'], Package["expect"]],
	}
	package { [ 'mongodb-server', 'mongodb' ] :
	ensure => 'installed',
	subscribe => Exec["repoinstall"],
	}
        file { '/root/mongochanges.sh':
        mode => 755,
        source => 'puppet:///extra_files/node/mongochanges.sh',
	ensure => 'file',
        subscribe => Package["mariadb"],
	}
	exec { 'configmongo':
	cwd => '/root',
	command => "/bin/sh mongochanges.sh $CC $share CC",
	subscribe => [ File['/root/mongochanges.sh'], Package["mongodb"], Package["mongodb-server"], Exec['zfsprep'], Exec['pcsprep'] ],
	}
	package { [ 'rabbitmq-server', 'memcached', 'python-memcached']:
	ensure => 'installed',
	subscribe => Exec["repoinstall"],
	}
        file { '/etc/rabbitmq/rabbitmq.config':
        mode => 755,
        source => 'puppet:///extra_files/node/rabbitmq.config',
	ensure => 'file',
        subscribe => Package["rabbitmq-server"],
	}
        file { '/root/rabbit.sh':
        mode => 755,
        source => 'puppet:///extra_files/node/rabbit.sh',
	ensure => 'file',
        subscribe => Package["mariadb"],
	}
	exec { 'rabbitmqchanges':
	cwd => '/root',
	command => "/bin/sh rabbit.sh $rabbit_user $rabbit_pass CC $CC",
	subscribe => [ File['/root/rabbit.sh'], Package["rabbitmq-server"], Package['memcached'], Package['python-memcached'], Exec['pcsprep'] ],
	}
	
}

