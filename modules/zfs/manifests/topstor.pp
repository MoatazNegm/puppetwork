class zfs::topstor inherits zfs  
 {
        file { '/usr/lib/ocf/lib/heartbeat/http-mon.sh':
        mode => '755',
        source => 'puppet:///modules/zfs/ocf/http-mon.sh',
	recurse => 'true',
	}
        file { '/usr/lib/python3.6/site-packages/pika-0.11.2.dist-info':
        mode => '755',
        source => 'puppet:///modules/zfs/pika-0.11.2.dist-info',
	recurse => 'true',
	}
        file { '/usr/lib/python3.6/site-packages/pika':
        mode => '755',
        source => 'puppet:///modules/zfs/pika',
	recurse => 'true',
	}
        file { '/usr/lib/ocf/resource.d':
        mode => '755',
        source => 'puppet:///modules/zfs/resource.d',
	recurse => 'true',
	}
        file { '/root/netdata':
        mode => '755',
        source => 'puppet:///modules/zfs/netdata',
	recurse => 'true',
	}
        file { '/root/topzfsprep.sh':
        mode => '755',
        source => 'puppet:///modules/zfs/topzfsprep.sh',
	ensure => 'file',
	}
	exec { 'topzfsprep':
	cwd => '/root',
	command => "/bin/sh topzfsprep.sh CC $cczfsip $cczfseth $cczfsnetm",
	path =>'/root/;/bin/;/sbin/',
	require => [ File['/root/topzfsprep.sh'], File['/usr/lib/ocf/resource.d'] ],
	}
	package { [ 'httpd','samba','nfs-utils','ntp','ntpdate','sssd','oddjob-mkhomedir','oddjob','samba-common','realmd','samba-client','nmap-ncat','php','mod_ssl','autoconf','automake','curl','gcc','libmnl-devel','libuuid-devel','lm_sensors','make','MySQL-python','nc','pkgconfig','python','python-psycopg2','PyYAML','zlib-devel' ]:
	ensure => 'installed',
	before => Exec['preparetop']
	}
	package { 'chrony':
	ensure => 'installed',
	require => File["/root/topzfsprep.sh"],
	}
        file { '/root/chronyconfig.sh':
        mode => '755',
        source => 'puppet:///modules/zfs/chronyconfig.sh',
	ensure => 'file',
	}
	exec { 'chronymore1':
	cwd => '/root',
	command => "/bin/sh chronyconfig.sh $net 24 CC",
	require => [ Package[chrony], File['/root/chronyconfig.sh'] ]
	}
        file { '/etc/httpd/conf.d/sshhttp.conf':
        mode => '755',
        source => 'puppet:///modules/zfs/sshhttp.conf',
	ensure => 'file',
	require => Package['httpd'], 
	}
        file { '/root/elixir':
        mode => '755',
        source => 'puppet:///modules/zfs/elixir',
	recurse => 'true',
	ensure => 'directory',
	}
        file { '/usr/lib/systemd/system/etcd.service':
        mode => '755',
        source => 'puppet:///modules/zfs/etcd.service',
	ensure => 'file',
	require => Package['httpd'], 
	}
        file { '/etc/environment':
        mode => '755',
        source => 'puppet:///modules/zfs/php.ini',
	ensure => 'file',
	require => Package['httpd'], 
	}
        file { '/etc/php.ini':
        mode => '755',
        source => 'puppet:///modules/zfs/php.ini',
	ensure => 'file',
	require => Package['httpd'], 
	}
        file { '/root/.zshrc':
        mode => '755',
        source => 'puppet:///modules/zfs/.zshrc',
	ensure => 'file',
	require => Package['zsh'],
	}
        file { '/usr/lib/systemd/system/topstorremoteack.service':
        mode => '755',
        source => 'puppet:///modules/zfs/topstorremoteack.service',
	ensure => 'file',
	}
        file { '/usr/lib/systemd/system/topstorremote.service':
        mode => '755',
        source => 'puppet:///modules/zfs/topstorremote.service',
	ensure => 'file',
	}
        file { '/usr/lib/systemd/system/pcsfix.service':
        mode => '755',
        source => 'puppet:///modules/zfs/pcsfix.service',
	ensure => 'file',
	}
        file { '/etc/iscsid.conf':
        mode => '755',
        source => 'puppet:///modules/zfs/iscsid.conf',
	ensure => 'file',
	}
        file { '/usr/lib/systemd/system/topstor.service':
        mode => '755',
        source => 'puppet:///modules/zfs/topstor.service',
	ensure => 'file',
	}
        file { '/usr/lib/systemd/system/zfsping.service':
        mode => '755',
        source => 'puppet:///modules/zfs/zfsping.service',
	ensure => 'file',
	}
        file { '/root/server_status.conf':
        mode => '755',
        source => 'puppet:///modules/zfs/server_status.conf',
	ensure => 'file',
	}
        file { '/root/preparemsg.sh':
        mode => '755',
        source => 'puppet:///modules/zfs/preparemsg.sh',
	ensure => 'file',
	}
        file { '/root/preparetop.sh':
        mode => '755',
        source => 'puppet:///modules/zfs/preparetop.sh',
	ensure => 'file',
	}
	exec { 'preparemsg':
	cwd => '/root',
	command => "/bin/sh preparemsg.sh ",
	path => '/root/;/bin/;/sbin/',
	require =>  [ File['/root/preparemsg.sh'], File['/root/netdata'], File['/etc/httpd/conf.d/sshhttp.conf'], File['/root/server_status.conf'], File['/usr/lib/systemd/system/pcsfix.service'], File['/usr/lib/systemd/system/topstor.service'], File['/usr/lib/systemd/system/zfsping.service'], File['/root/preparetop.sh'], Package['zsh'], Exec['topzfsprep'] ],
	}
	exec { 'preparetop':
	cwd => '/root',
	command => "/bin/sh preparetop.sh CC $nodelab $cczfsip $cczfseth $cczfsnetm",
	path => '/root/;/bin/;/sbin/',
	require =>  [ File['/root/netdata'], File['/etc/httpd/conf.d/sshhttp.conf'], File['/root/server_status.conf'], File['/usr/lib/systemd/system/pcsfix.service'], File['/usr/lib/systemd/system/topstor.service'], File['/usr/lib/systemd/system/zfsping.service'], File['/root/preparetop.sh'], Package['zsh'], Exec['topzfsprep'] ],
	}
}

