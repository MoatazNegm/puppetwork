class hell {
        file { '/root/pcsprep.sh':
        mode => 755,
        source => 'puppet:///extra_files/pcsprep.sh',
	ensure => 'file',
        notify => Exec[pcsprep],
	}
	exec { 'pcsprep':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh 192.168.0.98 24 centoszfs2c centoszfs1c CC enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	refreshonly => true,
	}
	exec { 'compute1':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh 192.168.0.97 24 centoszfs2c centoszfs1c compute1 enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File["/root/pcsprep.sh"],
	}
	exec { 'block1':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh 192.168.0.96 24 centoszfs2c centoszfs1c block1 enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File["/root/pcsprep.sh"],
	}
	exec { 'object1':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh 192.168.0.95 24 centoszfs2c centoszfs1c object1 enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File["/root/pcsprep.sh"],
	}
	exec { 'compute2':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh 192.168.0.94 24 centoszfs1c centoszfs2c compute2 enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File["/root/pcsprep.sh"],
	}
	exec { 'block2':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh 192.168.0.93 24 centoszfs1c centoszfs2c block2 enp0s3 ",
	path =>'/root/;/bin/;/sbin/',
	subscribe => File["/root/pcsprep.sh"],
	}
	exec { 'object2':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh 192.168.0.92 24 centoszfs1c centoszfs2c object2 enp0s3 ",
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
	command => "/bin/sh chronyconfig.sh 192.168.0.0 24",
	subscribe => Package[chrony],
	refreshonly => true,
	}
}

