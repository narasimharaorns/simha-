# These Terraform scripts will help to Launch the EC2 instance with user/pwd devops/devops

###  - Launching EC2 Instance

## Pre-requisites:

### Step-1: First choose the Region where you would like to create a resources

### Step-2: configure aws with ACCESS_KEY and SECRET_KEY.
#### Install the aws cli and configure it
#### $ aws configure

### Step-4: Set the following Variable Values in variables.tf file
####  - region
####  - ports

### Step-5: Launch the Instance
#### $ terraform init
#### $ terraform plan
#### $ terraform apply --auto-approve

### Step-6: Terminate the Instance
#### $ terraform destroy --auto-approve
