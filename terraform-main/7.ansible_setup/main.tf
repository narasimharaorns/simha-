terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~>3.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "local_file" "inventory" {
  filename  = "./files/hosts"
  content   = "[webserver]\nweb ansible_host=${aws_instance.Ansible_Web_Server.private_ip}\n[appserver]\napp ansible_host=${aws_instance.Ansible_App_Server.private_ip}\n[centos]\nweb\napp"
}
