#! /bin/bash

# Global Variables
LOG=/tmp/devops.log

yum update -y
# Set Hostname Jenkins
hostnamectl set-hostname tomcat-server

# add the user devops
useradd devops
# set password : the below command will avoid re entering the password
echo "devops" | passwd --stdin devops
echo "devops" | passwd --stdin ec2-user
# modify the sudoers file at /etc/sudoers and add entry
echo 'devops     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers
echo 'ec2-user     ALL=(ALL)      NOPASSWD: ALL' | sudo tee -a /etc/sudoers
# this command is to add an entry to file : echo 'PasswordAuthentication yes' | sudo tee -a /etc/ssh/sshd_config
# the below sed command will find and replace words with spaces "PasswordAuthentication no" to "PasswordAuthentication yes"
sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
service sshd restart

# Install Java
amazon-linux-extras install java-openjdk11 -y &>>$LOG

# Install Git SCM
yum install tree wget zip unzip gzip vim net-tools git bind-utils python2-pip jq -y &>>$LOG
git --version &>>$LOG

sudo su - devops -c "git config --global user.name 'devops'"
sudo su - devops -c "git config --global user.email 'devops@gmail.com'"

## Enable color prompt
curl -s https://gitlab.com/rns-app/linux-auto-scripts/-/raw/main/ps1.sh -o /etc/profile.d/ps1.sh
chmod +x /etc/profile.d/ps1.sh

## Enable idle shutdown
curl -s https://gitlab.com/rns-app/linux-auto-scripts/-/raw/main/idle.sh -o /boot/idle.sh
chmod +x /boot/idle.sh && chown devops:devops /boot/idle.sh
{ crontab -l -u devops; echo '*/10 * * * * sh -x /boot/idle.sh &>/tmp/idle.out'; } | crontab -u devops -

java -version &>>$LOG
git --version &>>$LOG

chown -R devops:devops /opt
# groupadd tomcat && useradd -M -s /bin/nologin -g tomcat -d /usr/local/tomcat tomcat

cd /opt/
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.70/bin/apache-tomcat-9.0.70.tar.gz
tar -xvf apache-tomcat-9.0.70.tar.gz &>>$LOG
mv apache-tomcat-9.0.70 tomcat
rm -f apache-tomcat-9.0.70.tar.gz

chown -R devops:devops /opt/tomcat/

# Verify the version of Tools
java -version
sudo bash /opt/tomcat/bin/version.sh

echo '# Systemd unit file for tomcat
[Unit]
Description=Apache Tomcat Web Application Container
After=syslog.target network.target
[Service]
Type=forking
Environment=JAVA_HOME=/usr/lib/jvm/java-11-openjdk-11.0.18.0.10-1.amzn2.0.1.x86_64
Environment=CATALINA_PID=/opt/tomcat/temp/tomcat.pid
Environment=CATALINA_HOME=/opt/tomcat/
Environment=CATALINA_BASE=/opt/tomcat/
Environment="CATALINA_OPTS=-Xms512M -Xmx512M -server -XX:+UseParallelGC"
Environment="JAVA_OPTS=-Djava.awt.headless=true -Djava.security.egd=file:/dev/./urandom"
ExecStart=/opt/tomcat/bin/startup.sh
ExecStop=/opt/tomcat/bin/shutdown.sh
# ExecStop=/bin/kill -15 $MAINPID
User=devops
Group=devops
[Install]
WantedBy=multi-user.target' > /etc/systemd/system/tomcat.service

# Tomcat Configuration
cp /tmp/tomcat/manager/context.xml /opt/tomcat/webapps/manager/META-INF/
cp /tmp/tomcat/conf/tomcat-users.xml /opt/tomcat/conf/
cp /tmp/tomcat/conf/context.xml /opt/tomcat/conf/
cp /tmp/tomcat/lib/mysql-connector.jar /opt/tomcat/lib/
cp /tmp/tomcat/conf/server.xml /opt/tomcat/conf/

systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat
