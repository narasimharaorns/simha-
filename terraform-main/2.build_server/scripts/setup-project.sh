#! /bin/bash

sleep 90

PROJECT_HOME="/opt/projects"
MAVEN_INSTALL_DIR="/opt/maven"

# Verify the version of Tools
java -version

# Setup the Maven Path Variable
echo "export M2_HOME=${MAVEN_INSTALL_DIR}" >> /home/devops/.bashrc
echo 'export M2=$M2_HOME/bin' >> /home/devops/.bashrc
echo 'export PATH=$M2:$PATH' >> /home/devops/.bashrc

source /home/devops/.bashrc

echo maven installed to ${MAVEN_INSTALL_DIR}
mvn --version

sudo mkdir $PROJECT_HOME
sudo chown -R devops:devops $PROJECT_HOME

cd $PROJECT_HOME
mvn archetype:generate -DgroupId=com.rns.app -DartifactId=maven-app -DarchetypeArtifactId=maven-archetype-quickstart -DjavaVersion=11 -DinteractiveMode=false
sed -i '/^<\/project>.*/i <properties>\n<java.version>11</java.version>\n<maven.compiler.source>${java.version}</maven.compiler.source>\n<maven.compiler.target>${java.version}</maven.compiler.target>\n</properties>' maven-app/pom.xml

mvn archetype:generate -DgroupId=com.rns.app -DartifactId=webapp -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false
sed -i '/^<\/project>.*/i <properties>\n<java.version>11</java.version>\n<maven.compiler.source>${java.version}</maven.compiler.source>\n<maven.compiler.target>${java.version}</maven.compiler.target>\n</properties>' webapp/pom.xml
