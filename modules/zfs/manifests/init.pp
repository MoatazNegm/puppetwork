class zfs ( 
$nodelab="usbdummy",
$cczfsip="10.11.11.244",
$cczfsnetm="24",
$cczfseth="enp0s8",
$cczfsinitip="10.11.11.254",
)
{ 
 	notify { "starting zfs": }
        file { ['/root/zfs.repo']:
        mode => '755',
        source => 'puppet:///modules/zfs/zfs.repo',
	ensure => 'file',
	}
        file { ['/root/preparezfs.sh']:
        mode => '755',
        source => 'puppet:///modules/zfs/preparezfs.sh',
	ensure => 'file',
	notify => Exec['preparezfs'],
	}
        file { ['/root/localrepo.repo']:
        mode => '755',
        source => 'puppet:///modules/zfs/localrepo.repo',
	ensure => 'file',
	}
        file { ['/root/repochange.sh']:
        mode => '755',
        source => 'puppet:///modules/zfs/repochange.sh',
	ensure => 'file',
	}
	exec { 'repochange':
	cwd => '/root',
	command => "/bin/sh repochange.sh ",
	require => [ File["/root/repochange.sh"], File["/root/localrepo.repo"] ],
	}
	package { "vim":
	ensure => "installed",
	require => Exec["repochange"],
	}
	exec { 'preparezfs':
	cwd => '/root',
	command => "/bin/sh preparezfs.sh ",
	timeout => 20000000,
	refreshonly=>true,
	require => [ Package["vim"], File["/root/zfs.repo"] ],
	}
	package { [ "zsh","expect","git","targetcli","iscsi-initiator-utils","pacemaker","pcs" ]:
	ensure => "installed",
	require => Exec['preparezfs']
	}
	exec { "done":
	command => "/bin/true",
	refreshonly => true,
	}
	
        file { ['/root/preparegraphite.sh']:
        mode => '755',
        source => 'puppet:///modules/zfs/preparegraphite.sh',
	ensure => 'file',
	}
        file { ['/root/preparepcs.sh']:
        mode => '755',
        source => 'puppet:///modules/zfs/preparepcs.sh',
	ensure => 'file',
	}
        file { ['/root/prepareiscsi.sh']:
        mode => '755',
        source => 'puppet:///modules/zfs/prepareiscsi.sh',
	ensure => 'file',
	}
        file { ['/root/preparepace.sh']:
        mode => '755',
        source => 'puppet:///modules/zfs/preparepace.sh',
	ensure => 'file',
	}
	exec { 'preparepace':
	cwd => '/root',
	command => "/bin/sh preparepace.sh ",
	require => [ File['/root/preparepace.sh'], Package["pcs"], Package['pacemaker'], Package['git'] ],
	}
	exec { 'prepareiscsi':
	cwd => '/root',
	command => "/root/prepareiscsi.sh ",
	require => [ Exec['preparepace'], File['/root/prepareiscsi.sh'], Package["targetcli"], Package['iscsi-initiator-utils']  ],
	}
	exec { 'preparegraphite':
	cwd => '/root',
	command => "/bin/sh preparegraphite.sh $cczfsip",
	require => [ File['/root/preparegraphite.sh'], File['/root/daemon.json'] ],
	}
	exec { 'preparepcs':
	cwd => '/root',
	command => "/bin/sh preparepcs.sh $cczfseth $cczfsnetm $cczfsinitip ",
	require => [ File['/root/preparepcs.sh'], Package['expect'], Package['pcs'], Package['pacemaker'] ],
	}
	notify { "finished scratch": }
   contain zfs::topstor
}
