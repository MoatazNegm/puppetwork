import "classes/*.pp"
class toolbox {
	file { "/root/puppetsimple.sh":
	owner => root, group => root, mode => 0755,
	content => "#!/bin/sh\npuppet agent --no-daemonize --onetime --verbose \n", 
	}
}

node 'centoszfs2c.local.com' {
	include toolbox
	include hell
}
