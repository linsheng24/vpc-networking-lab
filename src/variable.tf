variable "left_vpc_cidr" {
  default = "10.0.0.0/16"
}

variable "left_vpc_azs" {
  default = ["ap-northeast-1a", "ap-northeast-1c"]
}

variable "left_vpc_private_subnets" {
  default = ["10.0.0.0/24"]
}

variable "left_vpc_public_subnets" {
  default = ["10.0.100.0/24", "10.0.101.0/24"]
}

variable "right_vpc_cidr" {
  default = "10.1.0.0/16"
}

variable "right_vpc_az" {
  default = "ap-northeast-1a"
}

variable "right_vpc_cidr_block" {
  default = "10.1.0.0/24"
}

variable "key_pair_name" {
  default = "key"
}
