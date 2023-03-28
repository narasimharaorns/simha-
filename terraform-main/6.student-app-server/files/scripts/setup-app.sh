#! /bin/bash

LOG=/tmp/devops.log

sleep 60

# Verify the Data Base
sudo systemctl status mariadb

# Verify the version of Tools
java -version
sudo bash /opt/tomcat/bin/version.sh
mvn --version

# Load Application Schema
cd /opt/ && git clone https://gitlab.com/rns-app/student-app.git
sleep 15
mysql -uroot < /opt/student-app/dbscript/studentapp.sql
# mysql -ustudent -pstudent1

# Nginx Setup

sudo rm -rf /usr/share/nginx/html/*
cd /opt/ && git clone https://gitlab.com/rns-app/static-project.git
sudo cp -R /opt/static-project/iPortfolio/* /usr/share/nginx/html

# sudo sed -i -e '/location \/student/,+3 d' -e '/^        error_page 404/ i \\t location /student { \n\t\tproxy_pass http://localhost:8080/student;\n\t}\n' /etc/nginx/nginx.conf

sudo cp /opt/student-app/nginx/nginx.conf /etc/nginx/nginx.conf

sudo systemctl restart nginx

# Tomcat Configuration
cp /opt/student-app/tomcat/manager/context.xml /opt/tomcat/webapps/manager/META-INF/
cp /opt/student-app/tomcat/conf/tomcat-users.xml /opt/tomcat/conf/
cp /opt/student-app/tomcat/conf/context.xml /opt/tomcat/conf/
cp /opt/student-app/tomcat/lib/mysql-connector.jar /opt/tomcat/lib/

# Restart the Tomcat SErver
sudo systemctl stop tomcat
sudo systemctl start tomcat

# Deploy the Application

# Clone App and Deploy it to Tomcat SErver

sudo su - devops -c "cd /opt/student-app && mvn clean package -DskipTests"
cp /opt/student-app/target/studentapp*.war /opt/tomcat/webapps/student.war
