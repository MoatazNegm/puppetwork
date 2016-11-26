#import "classes/*.pp"
$cc = '10.11.11.98'
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
# run_what to install what : any thing empty, or 'all' means all to be installed' then : hell identity computeservice computenode neutron novaneutron dashboard # for zfs run scratch and topstor
$run_what='scratch'
node 'zfs1.localdomain' {
case $run_what {
	'scratch': { class { 'zfs': } }
#	'topstor': { class { 'topstor': }
}
}
node default {}
