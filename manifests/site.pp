import "classes/*.pp"
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
# run_what to install what : any thing empty, or 'all' means all to be installed' then : identity
$run_what='novaneutron'
class global_exec_path {
	Exec { path => [ '/bin/', '/sbin/', '/usr/bin/', '/usr/sbin/', '/root/' ]}
}
class toolbox {
	file { "/root/puppetsimple.sh":
	owner => root, group => root, mode => 0755,
	content => "#!/bin/sh\npuppet agent --no-daemonize --onetime --verbose \n", 
	}
}

node 'centoszfs2c.local.com' {
	include toolbox
case $run_what {
 	'identity': { include identity }
	'computeservice': { include compute1 }
	'computenode': { include computenode }
	'neutron': { include neutron }
	'novaneutron': { include novaneutron }
	default:  { 
		include hell 
	}
	}
}
