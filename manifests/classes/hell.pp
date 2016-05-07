class hell {
        file { '/root/pcsprep.sh':
        mode => 755,
        source => 'puppet:///extra_files/pcsprep.sh',
	ensure => 'file',
        notify => Exec[pcsprep],
	}
	exec { 'pcsprep':
	cwd => '/root',
	command => "/bin/sh pcsprep.sh 192.168.0.98 24 centoszfs2c centoszfs1c Man2",
	path =>'/root/;/bin/;/sbin/',
	refreshonly => true,
	}
}

