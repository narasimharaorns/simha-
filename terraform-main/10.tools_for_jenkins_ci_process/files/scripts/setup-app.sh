#! /bin/bash

LOG=/tmp/devops.log

sleep 60

# Verify the Data Base
sudo systemctl status mariadb

# Verify the version of Tools
java -version
sudo bash /opt/tomcat/bin/version.sh

# Tomcat Configuration
cp /tmp/tomcat/manager/context.xml /opt/tomcat/webapps/manager/META-INF/
cp /tmp/tomcat/conf/tomcat-users.xml /opt/tomcat/conf/
cp /tmp/tomcat/conf/context.xml /opt/tomcat/conf/
cp /tmp/tomcat/lib/mysql-connector.jar /opt/tomcat/lib/

# Restart the Tomcat SErver
sudo systemctl stop tomcat
sudo systemctl start tomcat
