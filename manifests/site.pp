import "classes/*.pp"
$CC = '10.11.11.98'
$compute1 = '10.11.11.97'
$block1 = '10.11.11.96'
$object1 = '10.11.11.95'
$compute2 = '10.11.11.94'
$block2 = '10.11.11.93'
$object2 = '10.11.11.92'
$net = '10.11.11.0'
$node1 = 'centoszfs1c'
$node2 = 'centoszfs2c'
$share = 'p1'
$mysql_pass = 'tmatem'
$rabbit_user = 'openstack'
$rabbit_pass = 'tmatem'
# run_what to install what : any thing empty, or 'all' means all to be installed' then : hell identity computeservice computenode neutron novaneutron dashboard
$run_what='neutron'
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
	'dashboard': { include dashboard }
	'hell':  { 
		include hell 
	}
	}
}
node 'centoszfs1c.local.com' {
	include toolbox
case $run_what {
 	'identity': { include nodeidentity }
	'computeservice': { include nodecompute1 }
	'computenode': { include nodecomputenode }
	'neutron': { include nodeneutron }
	'novaneutron': { include nodenovaneutron }
	'dashboard': { include nodedashboard }
	'hell':  { 
		include nodehell 
	}
	}
}
