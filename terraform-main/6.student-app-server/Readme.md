### These Terraform scripts will help to configure the student app application with the required Services...

####  - Launching EC2 Instance

##### Pre-requisites:

    Step-1: First choose the Region where you would like to create a resources

    Step-2: configure aws with ACCESS_KEY and SECRET_KEY.

        - Install the aws cli and configure it
        - $ aws configure

    Step-3: Set the following Variable Values in variables.tf file
        - region

    Step-4:  Error: Incase while starting the tomcat server using 'systemctl start tomcat', then set the JAVA_HOME variable value located in the 'InstallTomcat.sh'

#### Tools & Configurations

      - Tools
        - Maven
        - Nginx
        - Tomcat server
        - MariaDB

      - Configuration:
        - Nginx -> Tomcat -> DB Server


      - Application Deployment:
        - Static Application on Nginx Server
        - Dynamic Application On Tomcat
        - Schemas uploading to DB
