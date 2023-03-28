variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "ports" {
  type    = list(number)
  default = [22, 8081]
}

variable "instance_type" {
  type    = string
  default = "t2.small"
}

output "public_ip" {
  value = aws_instance.Nexus_Server.public_ip
}
