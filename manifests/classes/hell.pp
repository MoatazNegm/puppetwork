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
class hell {
        file { '/root/pcsprep.sh':
        mode => 755,
        source => 'puppet:///extra_files/pcsprep.sh',
	ensure => 'file',
        notify => Exec[pcsprep],
	}
	exec { 'pcsprep':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh $CC 24 $node2 $node1 CC enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	refreshonly => true,
	}
	exec { 'compute1':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh $compute1 24 $node2 $node1 compute1 enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File["/root/pcsprep.sh"],
	}
	exec { 'block1':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh $block1 24 $node2 $node1 block1 enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File["/root/pcsprep.sh"],
	}
	exec { 'object1':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh $object1 24 $node2 $node1 object1 enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File["/root/pcsprep.sh"],
	}
	exec { 'compute2':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh $compute2 24 $node1 $node2  compute2 enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File["/root/pcsprep.sh"],
	}
	exec { 'block2':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh $block2 24 $node1 $node2 block2 enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File["/root/pcsprep.sh"],
	}
	exec { 'object2':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh $object2 24 $node1 $node2 object2 enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File["/root/pcsprep.sh"],
	}
	package { 'chrony':
	ensure => 'installed',
	subscribe => File["/root/pcsprep.sh"],
	}
        file { '/root/chronyconfig.sh':
        mode => 755,
        source => 'puppet:///extra_files/chronyconfig.sh',
	ensure => 'file',
        notify => Exec[chronymore1],
	}
	exec { 'chronymore1':
	cwd => '/root',
	command => "/bin/sh chronyconfig.sh $net 24 CC",
	subscribe => Package[chrony],
	refreshonly => true,
	}
	package { 'centos-release-openstack-mitaka':
	ensure => 'installed',
	subscribe => File["/root/pcsprep.sh"],
	}
	package { 'expect':
	ensure => 'installed',
	subscribe => File["/root/pcsprep.sh"],
	}
	exec { 'repoinstall':
	cwd => '/root',
	command => "/bin/yum upgrade -y",
	subscribe => Package["centos-release-openstack-mitaka"],
	}
	package { 'python-openstackclient':
	ensure => 'installed',
	subscribe => Exec["repoinstall"],
	}
	package { 'openstack-selinux':
	ensure => 'installed',
	subscribe => Exec["repoinstall"],
	}
	package { 'mariadb':
	ensure => 'installed',
	subscribe => Exec["repoinstall"],
	}
	package { 'mariadb-server':
	ensure => 'installed',
	subscribe => Exec["repoinstall"],
	}
	package { 'python2-PyMySQL':
	ensure => 'installed',
	subscribe => Exec["repoinstall"],
	}
        file { '/root/openstackcnf.sh':
        mode => 755,
        source => 'puppet:///extra_files/openstackcnf.sh',
	ensure => 'file',
        subscribe => Package["mariadb"],
	}
	exec { 'openstackcnf':
	cwd => '/root',
	command => "/bin/sh openstackcnf.sh $CC $share ",
	subscribe => File['/root/openstackcnf.sh'], 
	}
        file { '/root/mysqlsecure.sh':
        mode => 755,
        source => 'puppet:///extra_files/mysqlsecure.sh',
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
        source => 'puppet:///extra_files/mongochanges.sh',
	ensure => 'file',
        subscribe => Package["mariadb"],
	}
	exec { 'configmongo':
	cwd => '/root',
	command => "/bin/sh mongochanges.sh $CC $share",
	subscribe => [ File['/root/mongochanges.sh'], Package["mongodb"], Package["mongodb-server"]],
	}
	package { 'rabbitmq-server':
	ensure => 'installed',
	subscribe => Exec["repoinstall"],
	}
        file { '/root/rabbit.sh':
        mode => 755,
        source => 'puppet:///extra_files/rabbit.sh',
	ensure => 'file',
        subscribe => Package["mariadb"],
	}
	exec { 'rabbitmqchanges':
	cwd => '/root',
	command => "/bin/sh rabbit.sh $rabbit_user $rabbit_pass",
	subscribe => [ File['/root/rabbit.sh'], Package["rabbitmq-server"]],
	}
	
}

