terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

# Configure the AWS provider

provider "aws" {
  region = var.region
}

# Create Secutity Group

resource "aws_security_group" "MyLab_Sec_Group" {
  name        = "Docker Security Group"
  description = "To allow inbound and outbound traffic to mylab"
  #vpc_id      = aws_vpc.MyLab-VPC.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ports
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }

  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow traffic"
  }

}

data "aws_ami" "aws_linux_2_latest" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*"]
  }
}

# Create an AWS EC2 Instance to host Docker

resource "aws_instance" "Docker_Server" {
  ami                         = data.aws_ami.aws_linux_2_latest.id
  instance_type               = var.instance_type
  vpc_security_group_ids      = [aws_security_group.MyLab_Sec_Group.id]
  associate_public_ip_address = true
  user_data                   = file("./scripts/InstallDocker.sh")

  tags = {
    Name = "Docker-Engine"
  }

  provisioner "local-exec" {
    command = "echo ${self.private_ip} >> private_ip.txt"
  }
}

# "cd /opt/ && git clone git@gitlab.com:venkat09docs/rns-devops/student-app.git",
# git clone git@gitlab.com:venkat09docs/rns-devops/student-app.git --config core.sshCommand="ssh -i /home/ec2-user/.ssh/id_rsa"
