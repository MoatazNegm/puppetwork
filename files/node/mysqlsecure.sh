#!/bin/sh
export PATH=/bin:/usr/bin:/sbin:/usr/sbin:/root
mysqlpass=`echo $@ | awk '{print $1}'`;
cat mysqlsecured | grep didit
if [ $? -ne 0 ]; then
 SECURE_MYSQL=$(expect -c "
 set timeout 10
 spawn mysql_secure_installation
 expect \"Enter current password for root (enter for none):\"
 send \"\r\"
 expect \"Change the root password?\"
 send \"y\r\"
 expect \"New password:\"
 send \"${mysqlpass}\r\"
 expect \"Re-enter new password:\"
 send \"${mysqlpass}\r\"
 expect \"Remove anonymous users?\"
 send \"y\r\"
 expect \"Disallow login remotely?\"
 send \"y\r\"
 expect \"Remove test database and acess to it?\"
 send \"y\r\"
 expect \"Reload privilege tables now?\"
 send \"y\r\"
 expect eof
 ")
 echo "$SECURE_MYSQL"
 echo didit > mysqlsecured 
fi
