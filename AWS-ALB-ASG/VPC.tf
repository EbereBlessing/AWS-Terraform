# Defining the VPC set up
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name        = "${var.tag}-vpc"
  }
}

# Public subnetss
resource "aws_subnet" "public_subnet1" { 
  tags = {
    Name = "${var.tag}-public_subnet1"
  }
  cidr_block        = var.public_subnet_cidr1  
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.az2
}
resource "aws_subnet" "public_subnet2" { 
  tags = {
    Name = "${var.tag}-public_subnet2"
  }
  cidr_block        = var.public_subnet_cidr2 
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.az1
}

# Private Subnet
resource "aws_subnet" "private_subnet2" { 
  tags = {
    Name = "${var.tag}-private_subnet2"
  }
  cidr_block        = var.private_subnet_cidr1 
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.az1
}
resource "aws_subnet" "private_subnet2" { 
  tags = {
    Name = "${var.tag}-private_subnet2"
  }
  cidr_block        = var.private_subnet_cidr2
  vpc_id            = aws_vpc.vpc.id
  availability_zone = var.az2
}
# Internet gateway for the public subnet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"        = "${var.tag}-igw"
  }
}


