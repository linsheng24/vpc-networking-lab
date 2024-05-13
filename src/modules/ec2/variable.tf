variable "name" {
  default = "ec2"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_name" {
  default = "key"
}

variable "subnet_id" {
  default = "<subnet-id>"
}

variable "vpc_id" {
  default = "<vpc-id>"
}
