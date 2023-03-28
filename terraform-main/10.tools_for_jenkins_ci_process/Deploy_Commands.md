
# Load Application Schema
cd /tmp/ && git clone https://gitlab.com/rns-app/student-app.git
mysql -uroot < /tmp/student-app/dbscript/studentapp.sql
# mysql -ustudent -pstudent1


# Install the Maven Tool

mvn_version=${mvn_version:-3.6.3}
url=https://dlcdn.apache.org/maven/maven-3/${mvn_version}/binaries/apache-maven-${mvn_version}-bin.tar.gz
install_dir=/opt/maven

if [ -d ${install_dir} ]; then
    mv ${install_dir} ${install_dir}.$(date + "%Y%m%d")
fi

mkdir ${install_dir}
chown -R ec2-user:ec2-user ${install_dir}

curl -fsSL ${url} | tar zx --strip-component=1 -C ${install_dir}

echo "export M2_HOME=${install_dir}" >> /home/ec2-user/.bashrc
echo 'export M2=$M2_HOME/bin' >> /home/ec2-user/.bashrc
echo 'export PATH=$M2:$PATH' >> /home/ec2-user/.bashrc

source /home/ec2-user/.bashrc

mvn --version &>>$LOG

# Nginx Setup

sudo rm -rf /usr/share/nginx/html/* &>>$LOG
cd /tmp/
git clone https://gitlab.com/rns-app/static-project.git
sudo cp -R /tmp/static-project/iPortfolio/* /usr/share/nginx/html

sudo sed -i -e '/location \/student/,+3 d' -e '/^        error_page 404/ i \\t location /student { \n\t\tproxy_pass http://localhost:8080/student;\n\t}\n' /etc/nginx/nginx.conf

sudo systemctl enable nginx &>>$LOG
sudo systemctl restart nginx &>>$LOG

# Deploy the Application

# Clone App and Deploy it to Tomcat SErver
cd /opt/ && git clone https://gitlab.com/rns-app/student-app.git
#source /home/ec2-user/.bashrc
cd student-app && mvn clean package -DskipTests
cp target/studentapp*.war /opt/tomcat/webapps/student.war
