class topstor {
        file { '/usr/lib/ocf/resource.d':
        mode => 755,
        source => 'puppet:///extra_files/resource.d',
	recurse => 'true',
	}
        file { '/root/topzfsprep.sh':
        mode => 755,
        source => 'puppet:///extra_files/topzfsprep.sh',
	ensure => 'file',
	}
	exec { 'topzfsprep':
	cwd => '/root',
	command => "/bin/sh topzfsprep.sh CC ",
	path =>'/root/;/bin/;/sbin/',
	require => [ File['/root/topzfsprep.sh'], File['/usr/lib/ocf/resource.d'] ],
	}
	package { 'zsh':
	ensure => 'installed',
	}
	package { 'chrony':
	ensure => 'installed',
	require => File["/root/topzfsprep.sh"],
	}
        file { '/root/chronyconfig.sh':
        mode => 755,
        source => 'puppet:///extra_files/chronyconfig.sh',
	ensure => 'file',
	}
	exec { 'chronymore1':
	cwd => '/root',
	command => "/bin/sh chronyconfig.sh $net 24 CC",
	require => [ Package[chrony], File['/root/chronyconfig.sh'] ]
	}
        file { '/root/preparetop.sh':
        mode => 755,
        source => 'puppet:///extra_files/preparetop.sh',
	ensure => 'file',
	}
	exec { 'preparetop':
	cwd => '/root',
	command => "/bin/sh preparetop.sh ",
	path =>'/root/;/bin/;/sbin/',
	require => File['/root/preparetop.sh'], 
	}
}

