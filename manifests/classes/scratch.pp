$nodelab="labtop"
class scratch {
	package { [ "expect","git","targetcli","iscsi-initiator-utils","pacemaker","pcs" ]:
	ensure => "installed",
	}
        file { ['/root/preparezfs.sh']:
        mode => 755,
        source => 'puppet:///extra_files/preparezfs.sh',
	ensure => 'file',
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
	subscribe => [ File['/root/preparepace.sh'], Package["git"] ],
	}
	exec { 'prepareiscsi':
	cwd => '/root',
	command => "/bin/sh prepareiscsi.sh ",
	subscribe => [ File['/root/prepareiscsi.sh'], Package["targetcli"], Package["iscsi-initiator-utils"] ],
	}
	exec { 'preparepcs':
	cwd => '/root',
	command => "/bin/sh preparepcs.sh $nodelab",
	subscribe => [ File['/root/preparepcs.sh'], Package["pacemaker"] ],
	}
	exec { 'preparezfs':
	cwd => '/root',
	command => "/bin/sh preparezfs.sh ",
	subscribe => File['/root/preparezfs.sh'],
	}
}
