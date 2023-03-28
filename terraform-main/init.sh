## COLORS
N="\e[0m"
GBP() {
  GB="\e[32m"
  echo -e "${GB}${1}${N}"
}

YBP() {
  YB="\e[1;33m"
  echo -e "${YB}${1}${N}"
}

BP() {
  echo -e "\e[1m${1}\e[0m"
}


CHOOSE_ENVIRONMENT_TO_LAUNCH() {
  YBP "Choose Environment"
  YBP "--------------------"
  BP  "1. ec2 server"
  BP  "2. Build Server"
  BP  "3. Tomcat Server"
  BP  "4. MySql Server"
  BP  "5. Nexus Server"
  BP "6. Student App Server"
  BP "7. Ansible Setup"
  BP "8. Jenkins Setup"
  BP "9. Staging Env for Jenkins CI Process"
  read -p "Select Environment to Launch> " environment
  case $environment in
    1) echo "Launching EC2 Instance"
       cd 1.ec2_server
       terraform init && terraform apply --auto-approve;;
    2) echo "Launching 'Maven' Build Server"
       cd 2.build_server
       terraform init && terraform apply --auto-approve;;
    3) echo "Launching Tomcat Server"
       cd 3.tomcat_server
       terraform init && terraform apply --auto-approve;;
    4) echo "Launching MySql DB Server"
       cd 4.mysql_server
       terraform init && terraform apply --auto-approve;;
    5) echo "Launching Nexus Server"
       cd 5.nexus_server
       terraform init && terraform apply --auto-approve;;
    6) echo "Launching Student App Server"
       cd 6.student-app-server
       terraform init && terraform apply --auto-approve;;
    7) echo "Launching Ansible 3 Nodes"
       cd 7.ansible_setup
       terraform init && terraform apply --auto-approve;;
    8) echo "Launching Jenkins Nodes"
       cd 8.jenkins_setup
       terraform init && terraform apply --auto-approve;;
    9) echo "Launching Staging Env for Jenkins CI Process"
       cd 9.tools_for_jenkins_ci_process
       terraform init && terraform apply --auto-approve;;
    *)
      echo "Choosen Environment is Invalid!!!"
      exit
      #echo "Enter your Instance Type: "
      ;;
  esac
}

CHOOSE_ENVIRONMENT_TO_DESTROY() {
  YBP "Choose Environment"
  YBP "--------------------"
  BP  "1. ec2 server"
  BP  "2. Build Server"
  BP  "3. Tomcat Server"
  BP  "4. MySql Server"
  BP  "5. Nexus Server"
  BP  "6. Student App Server"
  BP  "7. Ansible Setup"
  BP  "8. Jenkins Setup"
  BP  "9. Staging Env for Jenkins CI Process"
  read -p "Select Environment to Destroy> " environment
  case $environment in
    1) echo "Terminating EC2 Instance"
       cd 1.ec2_server && terraform destroy --auto-approve;;
    2) echo "Terminating 'Maven' Build Server"
       cd 2.build_server && terraform destroy --auto-approve;;
    3) echo "Terminating Tomcat Server"
       cd 3.tomcat_server && terraform destroy --auto-approve;;
    4) echo "Terminating MySql DB Server"
       cd 4.mysql_server && terraform destroy --auto-approve;;
    5) echo "Terminating Nexus Server"
       cd 5.nexus_server && terraform destroy --auto-approve;;
    6) echo "Terminating Student App Server"
       cd 6.student-app-server && terraform destroy --auto-approve;;
    7) echo "Terminating Ansible 3 Nodes"
       cd 7.ansible_setup && terraform destroy --auto-approve;;
    8) echo "Terminating Jenkins Nodes"
       cd 8.jenkins_setup && terraform destroy --auto-approve;;
    9) echo "Terminating Staging Env for Jenkins CI Process"
       cd 9.tools_for_jenkins_ci_process && terraform destroy --auto-approve;;
    *)
      echo "Choosen Environment is Invalid!!!"
      exit
      #echo "Enter your Instance Type: "
      ;;
  esac
}

YBP "Choose Activity Type"
YBP "--------------------"
BP "1. Launch Environment"
BP "2. Destroy Environment"

read -p "Do you want Launch Env or Destroy?  " activity
case $activity in
  1) CHOOSE_ENVIRONMENT_TO_LAUNCH
     ;;
  2) CHOOSE_ENVIRONMENT_TO_DESTROY
     ;;
  *)
     echo "Choosen Activity is Invalid!!!"
     exit
       #echo "Enter your Instance Type: "
     ;;
 esac
