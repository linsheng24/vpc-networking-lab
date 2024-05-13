module "left_vpc" {
  source = "terraform-aws-modules/vpc/aws"

  cidr = var.left_vpc_cidr

  azs             = var.left_vpc_azs
  private_subnets = var.left_vpc_private_subnets
  public_subnets  = var.left_vpc_public_subnets

  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_support   = true
  enable_dns_hostnames = true

  map_public_ip_on_launch = true

  tags = {
    Name = "left-vpc"
    task = "2-1"
  }

  public_subnet_tags = {
    Name = "left-public-subnet"
    task = "2-1"
  }

  private_subnet_tags = {
    Name = "left-private-subnet"
    task = "2-1"
  }

  public_route_table_tags = {
    Name = "left-public-rt"
    task = "2-1"
  }

  private_route_table_tags = {
    Name = "left-private-rt"
    task = "2-1"
  }
}

resource "aws_vpc" "right_vpc" {
  cidr_block           = "10.1.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "right-vpc"
    task = "2-1"
  }
}

resource "aws_subnet" "right_public_subnet" {
  vpc_id                  = aws_vpc.right_vpc.id
  cidr_block              = var.right_vpc_cidr_block
  availability_zone       = var.right_vpc_az
  map_public_ip_on_launch = true

  tags = {
    Name = "right-public_subnet"
    task = "2-1"
  }
}

resource "aws_internet_gateway" "right_igw" {
  vpc_id = aws_vpc.right_vpc.id

  tags = {
    Name = "right-igw"
    task = "2-1"
  }
}

resource "aws_route_table" "right_rtb_public" {
  vpc_id = aws_vpc.right_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.right_igw.id
  }

  route {
    cidr_block                = "10.0.0.0/16"
    vpc_peering_connection_id = aws_vpc_peering_connection.main.id
  }

  tags = {
    Name = "right-public-route-table"
    task = "2-1"
  }
}

resource "aws_route" "left_to_right" {
  route_table_id            = module.left_vpc.private_route_table_ids[0]
  destination_cidr_block    = aws_vpc.right_vpc.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.main.id
}

resource "aws_route_table_association" "right_rta" {
  subnet_id      = aws_subnet.right_public_subnet.id
  route_table_id = aws_route_table.right_rtb_public.id
}


resource "aws_vpc_peering_connection" "main" {
  vpc_id      = module.left_vpc.vpc_id
  peer_vpc_id = aws_vpc.right_vpc.id
  auto_accept = true

  accepter {
    allow_remote_vpc_dns_resolution = true
  }
}
