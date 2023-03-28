variable "region" {
  type    = string
  default = "eu-west-1"
}

variable "ports" {
  type    = list(number)
  default = [22, 80, 8080, 8000]
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}

output "public_ip" {
  value = aws_instance.Kops_Node.public_ip
}
