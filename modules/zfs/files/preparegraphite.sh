#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
systemctl enable docker
systemctl start docker
if [ $? -eq 0 ];
then
 docker run -d --name=graphite --restart=always -p 8080:80 -p 2003-2004:2003-2004 -p 2023-2024:2023-2024 -p 8125:8125/udp -p 8126:8126 10.11.11.124:5000/graphite
fi
