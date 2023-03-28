variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "availability_zone" {
  type    = string
  default = "eu-west-1a"
}

variable "ports" {
  type    = list(number)
  default = [22, 80, 443, 8080]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

output "public_ip" {
  value = aws_instance.Tomcat_Server.public_ip
}
