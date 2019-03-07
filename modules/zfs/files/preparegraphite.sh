#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
mkdir /etc/docker/
manip=`echo $@ | awk '{print $1}'`
cp /root/daemon.json /etc/docker/
systemctl enable docker
systemctl start docker
if [ $? -eq 0 ];
then
 docker run -d --name=graphite --restart=always -p 8080:80 -p 2003-2004:2003-2004 -p 2023-2024:2023-2024 -p 8125:8125/udp -p 8126:8126 10.11.11.124:5000/graphite
 docker run -d --name=prom --restart=always -p 9090:9090 -v /etc/prometheus.yml:/etc/prometheus/prometheus.yml 10.11.11.124:5000/prom  
 docker run -d --name=nodeprm --restart=always -p 9100:9100 -v "/proc:/host/proc" -v "/sys:/host/sys" -v "/:/rootfs" --net="host" 10.11.11.124:5000/nodeprm --path.procfs /host/proc --path.sysfs /host/sys --collector.filesystem.ignored-mount-points "^(sys|dev|proc|host|etc)($|/)"
 docker run -d --name=grafana --restart=always -p 3000:3000 -e "GF_SECURITY_ADMIN_PASSWORD=tmatem" 10.11.11.124:5000/grafana
fi
