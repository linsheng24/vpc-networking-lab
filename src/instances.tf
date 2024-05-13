module "left_public_ec2" {
  source = "./modules/ec2"

  name      = "left_public_ec2"
  key_name  = var.key_pair_name
  vpc_id    = module.left_vpc.vpc_id
  subnet_id = module.left_vpc.public_subnets[0]
}

module "left_private_ec2" {
  source = "./modules/ec2"

  name      = "left_private_ec2"
  key_name  = var.key_pair_name
  vpc_id    = module.left_vpc.vpc_id
  subnet_id = module.left_vpc.private_subnets[0]
}

module "right_public_ec2" {
  source = "./modules/ec2"

  name      = "right_public_ec2"
  key_name  = var.key_pair_name
  vpc_id    = aws_vpc.right_vpc.id
  subnet_id = aws_subnet.right_public_subnet.id
}
