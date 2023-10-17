# main.tf
## Defining terraform provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.31.0"
    }
  }
}
provider "aws" {
  region = var.region
}
# VPC
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name        = "${var.tag}-vpc"
  }
}
# Public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.public_subnets_cidr)
  cidr_block              = element(var.public_subnets_cidr, count.index)
  availability_zone       = element(var.public_AZ, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name  = "${var.tag}-${element(var.public_AZ, count.index)}-public-subnet"
  }
}
# Route table associations for both Public subnet
resource "aws_route_table_association" "public" {
  count          = length(var.public_subnets_cidr)
  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

# Private Subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.vpc.id
  count                   = length(var.private_subnets_cidr)
  cidr_block              = element(var.private_subnets_cidr, count.index)
  availability_zone       = element(var.private_AZ, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name  = "${var.tag}-${element(var.private_AZ, count.index)}-private-subnet"
  }
}
# Route table associations for both Private subnet
resource "aws_route_table_association" "private" {
  count          = length(var.private_subnets_cidr)
  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
  route_table_id = aws_route_table.private.id
}

#Internet gateway
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    "Name"        = "${var.tag}-igw"
  }
}

# Elastic-IP (eip) for NAT
resource "aws_eip" "NAT_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.NAT_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  tags = {
    Name  = "nat-gateway-${var.tag}"
  }
}
# Routing tables to route traffic for Private Subnet
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name  = "${var.tag}-private-route-table"
  }
}
# Route for NAT Gateway
resource "aws_route" "private_internet_gateway" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_nat_gateway.nat.id
}

# Routing tables to route traffic for Public Subnet
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name   = "${var.tag}-public-route-table"
  }
}
# Route for Internet Gateway
resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
## ssh connectivity
resource "aws_key_pair" "vpn_key" {
  key_name = "vpn-key"
  public_key = file("~/.ssh/id_rsa.pub") 
}
# Creating a security group named sg
resource "aws_security_group" "public_sg" {
  # Name, Description and the VPC of the Security Group
  name = "sg"
  vpc_id      = aws_vpc.vpc.id
  description = "Security group"
  # Since Jenkins runs on port 8080, we are allowing all traffic from the internet
  # to be able to access the EC2 instance on port 8080
  ingress {
    description = "Allow all traffic through port 8080"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Since we only want to be able to SSH into the Jenkins EC2 instance, we are only
  # allowing traffic from our IP on port 22
  ingress {
    description = "Allow SSH from my computer"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # We want the Jenkins EC2 instance to being able to talk to the internet
  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
# EC2 instance in Public Subnet
resource "aws_instance" "public_instance" {
  count         = length(var.public_subnets_cidr)
  ami           = var.os # Replace with the desired AMI ID
  instance_type = var.instance   # Replace with the desired instance type
  vpc_security_group_ids = [aws_security_group.public_sg.id]
  subnet_id     = element(aws_subnet.public_subnet.*.id, count.index)
  key_name      = "vpn-key"  # Replace with your SSH key pair
  tags = {
    Name = "${var.tag}-public-instance-${count.index + 1}"
  }
}

# EC2 instance in Private Subnet
resource "aws_instance" "private_instance" {
  count         = length(var.private_subnets_cidr)
  ami           = var.os  # Replace with the desired AMI ID
  instance_type = var.instance     # Replace with the desired instance type
  subnet_id     = element(aws_subnet.private_subnet.*.id, count.index)
  key_name      = "vpn-key"  # Replace with your SSH key pair
  tags = {
    Name = "${var.tag}-private-instance-${count.index + 1}"
  }
}





