#! /bin/bash

# Global Variables
LOG=/tmp/devops.log

yum update -y
# Set Hostname Jenkins
hostnamectl set-hostname app-server

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
wget https://dlcdn.apache.org/tomcat/tomcat-9/v9.0.72/bin/apache-tomcat-9.0.72.tar.gz
tar -xvf apache-tomcat-9.0.72.tar.gz &>>$LOG
mv apache-tomcat-9.0.72 tomcat
rm -f apache-tomcat-9.0.72.tar.gz

chown -R devops:devops /opt/tomcat/

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

systemctl daemon-reload
systemctl start tomcat
systemctl enable tomcat

# script to install maven

install_dir="/opt/maven"

if [ -d ${install_dir} ]; then
    mv ${install_dir} ${install_dir}.$(date +"%Y%m%d")
fi

VERSION=$(curl -s https://maven.apache.org/download.cgi  | grep Downloading |awk '{print $NF}' |awk -F '<' '{print $1}')
cd /opt
curl -s https://archive.apache.org/dist/maven/maven-3/${VERSION}/binaries/apache-maven-${VERSION}-bin.zip -o /tmp/apache-maven-${VERSION}-bin.zip
unzip /tmp/apache-maven-${VERSION}-bin.zip
mv apache-maven-${VERSION} maven
chown -R devops:devops ${install_dir}
ln -s /opt/maven/bin/mvn /bin/mvn

# Install the Nginx Server

echo "Web Server Setup"

amazon-linux-extras install nginx1 -y &>>$LOG

# rm -rf /usr/share/nginx/html/* &>>$LOG

systemctl enable nginx &>>$LOG
systemctl restart nginx &>>$LOG

# Install Maria Db Database

yum install mariadb-server mysql -y

systemctl enable mariadb
systemctl start mariadb
