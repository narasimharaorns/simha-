variable "region" {
  type    = string
  default = "eu-west-1"
  #default = "ap-south-1"
}

variable "ports" {
  type    = list(number)
  default = [22, 80, 443, 8080, 3306]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

output "public_ip" {
  value = aws_instance.Deployment_Server.public_ip
}
