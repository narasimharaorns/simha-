#! /bin/bash

# Global Variables
LOG=/tmp/devops.log
G="\e[32m"
R="\e[31m"
N="\e[0m"

# Heading Function
HEADING() {
  echo -e "\n\t\t\e[1;4;33m$1\e[0m\n"
}

# Status check function
STATUS_CHECK() {
  if [ $1 -eq 0 ]; then
    echo -e "$2 -- ${G}SUCCESS${N}"
  else
    echo -e "$2 -- ${R}FAILURE${N}"
    exit 1
  fi
}

sleep 60

# Download Nexus
cd /opt/
sudo wget https://download.sonatype.com/nexus/3/latest-unix.tar.gz
sudo chown -R devops:devops /opt
# Unzip/Untar the compressed file
tar xf latest-unix.tar.gz
# Rename folder for ease of use
mv nexus-3.* nexus3
# Enable permission for ec2-user to work on nexus3 and sonatype-work folders
chown -R devops:devops nexus3/ sonatype-work/
# Create a file called nexus.rc and add run as ec2-user
cd /opt/nexus3/bin/
#touch nexus.rc
#echo 'run_as_user="devops"' | sudo tee -a /opt/nexus3/bin/nexus.rc
sed -i 's/^#.*/run_as_user="devops"/g' /opt/nexus3/bin/nexus.rc
# Add nexus as a service at boot time
#ln -s /opt/nexus3/bin/nexus /etc/init.d/nexus
#chown -h devops:devops /etc/rc.d/init.d/nexus

sudo echo '[Unit]
Description=nexus service
After=network.target

[Service]
Type=forking
LimitNOFILE=65536
ExecStart=/opt/nexus3/bin/nexus start
ExecStop=/opt/nexus3/bin/nexus stop
User=devops
Group=devops
Restart=on-abort
TimeoutSec=600

[Install]
WantedBy=multi-user.target' | sudo tee -a /etc/systemd/system/nexus.service
sudo chown devops:devops /etc/systemd/system/nexus.service
sudo chmod +x /etc/systemd/system/nexus.service
# Start Nexus
sudo systemctl daemon-reload
sudo systemctl start nexus
sudo systemctl enable nexus
