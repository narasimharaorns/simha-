variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "ports" {
  type    = list(number)
  default = [22, 80, 443, 8080, 8081, 9000]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

output "public_ip" {
  value = aws_instance.Tomcat_Server.public_ip
}
