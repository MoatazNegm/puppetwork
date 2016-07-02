class topstor {
        file { '/usr/lib/ocf/lib/heartbeat/http-mon.sh':
        mode => 755,
        source => 'puppet:///extra_files/ocf/http-mon.sh',
	recurse => 'true',
	}
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
	command => "/bin/sh topzfsprep.sh CC $CCzfsip $CCzfseth $CCzfsnetm",
	path =>'/root/;/bin/;/sbin/',
	require => [ File['/root/topzfsprep.sh'], File['/usr/lib/ocf/resource.d'] ],
	}
	package { [ 'nfs-utils','ntp','ntpdate','sssd','oddjob-mkhomedir','oddjob','samba-common','realmd','samba','samba-client','zsh','nmap-ncat','httpd','php','mod_ssl' ]:
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
        file { '/etc/httpd/conf.d/sshhttp.conf':
        mode => 755,
        source => 'puppet:///extra_files/sshhttp.conf',
	ensure => 'file',
	require => Package['httpd'], 
	}
        file { '/root/.zshrc':
        mode => 755,
        source => 'puppet:///extra_files/.zshrc',
	ensure => 'file',
	require => Package['zsh'],
	}
        file { '/usr/lib/systemd/system/pcsfix.service':
        mode => 755,
        source => 'puppet:///extra_files/pcsfix.service',
	ensure => 'file',
	}
        file { '/usr/lib/systemd/system/topstor.service':
        mode => 755,
        source => 'puppet:///extra_files/topstor.service',
	ensure => 'file',
	}
        file { '/root/server_status.conf':
        mode => 755,
        source => 'puppet:///extra_files/server_status.conf',
	ensure => 'file',
	}
        file { '/root/preparetop.sh':
        mode => 755,
        source => 'puppet:///extra_files/preparetop.sh',
	ensure => 'file',
	}
	exec { 'preparetop':
	cwd => '/root',
	command => "/bin/sh preparetop.sh CC $nodelab $CCzfsip $CCzfseth $CCzfsnetm",
	path =>'/root/;/bin/;/sbin/',
	require => [ Package['nfs-utils'], Package ['samba'], File['/etc/httpd/conf.d/sshhttp.conf'],  File['/root/server_status.conf'], File['/usr/lib/systemd/system/pcsfix.service'], File['/usr/lib/systemd/system/topstor.service'], File['/root/preparetop.sh'], Package['zsh'], Exec['topzfsprep'] ],
	}
}

