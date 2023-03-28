### Launch EC2 Instance using Terraform:

On windows System:

    $ cd /d/workspace/

    $ ll

    $ git clone https://gitlab.com/rns-devops/terraform.git

    $ ll

    $ cd terraform/

    $ ll

    $ cd 1.ec2_server/

    $ ll

    $ atom .
      Edit variables.tf file to specify the Region and Ports.

    $ terraform init

    $ terraform plan

    $ terraform apply --auto-approve


Use the MobaXterm and Login to the EC2 Instance with Public IP Address.

#### Install Java

    $ java -version

    $ sudo amazon-linux-extras install java-openjdk11 -y

    $ java -version

#### Install Maven

    $ ll /opt/

    $ sudo chown -R devops:devops /opt

    $ install_dir="/opt/maven"

    $ echo $install_dir

    $ VERSION=$(curl -s https://maven.apache.org/download.cgi  | grep Downloading |awk '{print $NF}' |awk -F '<' '{print $1}')

    $ cd /opt

    $ curl -s https://archive.apache.org/dist/maven/maven-3/${VERSION}/binaries/apache-maven-${VERSION}-bin.zip -o /tmp/apache-maven-${VERSION}-bin.zip

    $ unzip /tmp/apache-maven-${VERSION}-bin.zip

    $ ll

    $ mv apache-maven-${VERSION} maven

    $ ll maven/

    $ sudo chown -R devops:devops ${install_dir}

    $ mvn --version

    $ sudo ln -s /opt/maven/bin/mvn /bin/mvn

    $ mvn --version

    $ java -version


#### Create Java Projects using Maven

    $ PROJECT_HOME="/opt/projects"

    $ mkdir $PROJECT_HOME

    $ sudo chown -R devops:devops $PROJECT_HOME

    $ ll /opt/

    $ cd $PROJECT_HOME

    $ ll

    $ mvn archetype:generate -DgroupId=com.rns.app -DartifactId=maven-app -DarchetypeArtifactId=maven-archetype-quickstart -DjavaVersion=11 -DinteractiveMode=false

    $ sed -i '/^<\/project>.*/i <properties>\n<java.version>11</java.version>\n<maven.compiler.source>${java.version}</maven.compiler.source>\n<maven.compiler.target>${java.version}</maven.compiler.target>\n</properties>' maven-app/pom.xml

    $ mvn archetype:generate -DgroupId=com.rns.app -DartifactId=webapp -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false

    $ sed -i '/^<\/project>.*/i <properties>\n<java.version>11</java.version>\n<maven.compiler.source>${java.version}</maven.compiler.source>\n<maven.compiler.target>${java.version}</maven.compiler.target>\n</properties>' webapp/pom.xml

    $ ll

    $ ll maven-app/
    $ ll webapp


#### Destroy the EC2 Instance
    $ terraform destroy --auto-approve
