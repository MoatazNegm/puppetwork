#!/bin/sh
myhost=`hostname`
myl3id=$(echo "use neutron; select id,host from agents where agents.agent_type='l3 agent';" | mysql -uroot -ptmatem | grep -w $myhost | awk '{print $1}')
myid="'"${myl3id}"'";
echo "use neutron; UPDATE routerl3agentbindings SET routerl3agentbindings.l3_agent_id=$myid;" | mysql -uroot -ptmatem



