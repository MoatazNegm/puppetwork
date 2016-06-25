$nodelab="topstorlin"
$CCzfsip="192.168.0.22"
$CCzfsnetm="24"
$CCzfseth="enp0s9"
class scratch {
        file { ['/root/preparezfs.sh']:
        mode => 755,
        source => 'puppet:///extra_files/preparezfs.sh',
	ensure => 'file',
	notify => Exec['preparezfs'],
	}
	exec { 'preparezfs':
	cwd => '/root',
	command => "/bin/sh preparezfs.sh ",
	timeout => 20000000,
	refreshonly=>true,
	}
	package { [ "expect","git","targetcli","iscsi-initiator-utils","pacemaker","pcs" ]:
	ensure => "installed",
	require => Exec['preparezfs'],
	}
	exec { "done":
	command => "/bin/true",
	refreshonly => true,
	}
	
        file { ['/root/preparepcs.sh']:
        mode => 755,
        source => 'puppet:///extra_files/preparepcs.sh',
	ensure => 'file',
	}
        file { ['/root/prepareiscsi.sh']:
        mode => 755,
        source => 'puppet:///extra_files/prepareiscsi.sh',
	ensure => 'file',
	}
        file { ['/root/preparepace.sh']:
        mode => 755,
        source => 'puppet:///extra_files/preparepace.sh',
	ensure => 'file',
	}
	exec { 'preparepace':
	cwd => '/root',
	command => "/bin/sh preparepace.sh ",
	require => [ File['/root/preparepace.sh'], Package["pcs"], Package['pacemaker'], Package['git'] ],
	}
	exec { 'prepareiscsi':
	cwd => '/root',
	command => "/bin/sh prepareiscsi.sh $nodelab",
	require => [ Exec['preparepace'], File['/root/prepareiscsi.sh'], Package["targetcli"], Package['iscsi-initiator-utils']  ],
	}
	exec { 'preparepcs':
	cwd => '/root',
	command => "/bin/sh preparepcs.sh $nodelab",
	require => [ File['/root/preparepcs.sh'], Package['expect'], Package['pcs'], Package['pacemaker'] ],
	}
}
