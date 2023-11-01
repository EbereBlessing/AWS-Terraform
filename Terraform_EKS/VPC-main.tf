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
# Create VPC
resource "aws_vpc" "main" {
  cidr_block = var.vpc_block
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "${var.stack_name}-VPC"
  }
}
# Create Internet Gateway
resource "aws_internet_gateway" "main" {
    vpc_id = aws_vpc.main.id 
    tags = {
    "Name"        = "${var.stack_name}-igw"
  }
}

# Create Public Route Table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name     = "Public Subnets Route Table"
    Network  = "Public"
  }
}
# Create Private Route Tables
resource "aws_route_table" "private_01" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name     = "Private Route Table AZ1"
    Network  = "Private01"
  }
}

resource "aws_route_table" "private_02" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name     = "Private Route Table AZ2"
    Network  = "Private02"
  }
}

# Create Public Route
resource "aws_route" "public" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main.id

}

# Create NAT Gateways
resource "aws_eip" "nat_gateway_01" {
     vpc        = true
}

resource "aws_eip" "nat_gateway_02" {
     vpc        = true
}

resource "aws_nat_gateway" "nat_gateway_01" {
  allocation_id = aws_eip.nat_gateway_01.id
  count = 1  # This should match the count from the subnet block
  subnet_id = aws_subnet.public_subnet_01[count.index].id
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.stack_name}-NatGatewayAZ1"
  } 
}

resource "aws_nat_gateway" "nat_gateway_02" {
  allocation_id = aws_eip.nat_gateway_02.id
  count = 1
  subnet_id     = aws_subnet.public_subnet_02[count.index].id
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.stack_name}-NatGatewayAZ2"
  }
}

# Create Public Subnets
resource "aws_subnet" "public_subnet_01" {
  count = 1
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, 0)
  cidr_block = var.public_subnet_01_block
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.stack_name}-PublicSubnet01"
    "kubernetes.io/role/elb" = "1"
  }
}

resource "aws_subnet" "public_subnet_02" {
  count = 1
  map_public_ip_on_launch = true
  availability_zone = element(data.aws_availability_zones.available.names, 1)
  cidr_block = var.public_subnet_02_block
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.stack_name}-PublicSubnet02"
    "kubernetes.io/role/elb" = "1"
  }
}

# Create Private Subnets
resource "aws_subnet" "private_subnet_01" {
  count = 1
  availability_zone = element(data.aws_availability_zones.available.names, 0)
  cidr_block = var.private_subnet_01_block
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.stack_name}-PrivateSubnet01"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

resource "aws_subnet" "private_subnet_02" {
  count = 1
  availability_zone = element(data.aws_availability_zones.available.names, 1)
  cidr_block = var.private_subnet_02_block
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.stack_name}-PrivateSubnet02"
    "kubernetes.io/role/internal-elb" = "1"
  }
}

# Associate Subnets with Route Tables
resource "aws_route_table_association" "public_subnet_01" {
  subnet_id      = aws_subnet.public_subnet_01[0].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_subnet_02" {
  subnet_id      = aws_subnet.public_subnet_02[0].id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "private_subnet_01" {
  subnet_id      = aws_subnet.private_subnet_01[0].id
  route_table_id = aws_route_table.private_01.id
}

resource "aws_route_table_association" "private_subnet_02" {
  subnet_id      = aws_subnet.private_subnet_02[0].id
  route_table_id = aws_route_table.private_02.id
}

# Create Security Group for Control Plane
resource "aws_security_group" "control_plane" {
  name_prefix = "Cluster communication with worker nodes"
  vpc_id      = aws_vpc.main.id
   ingress {
    description = "Allow all traffic through port 8080"
    from_port = 8080
    to_port = 8080
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # Since we only want to be able to SSH into the  EC2 instance, we are only
  # allowing traffic from our IP on port 22
  ingress {
    description = "Allow SSH from my computer"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  # We want the  instance to being able to talk to the internet
  egress {
    description = "Allow all outbound traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Define Outputs
output "subnet_ids" {
  description = "Subnets IDs in the VPC"
  value = join(",", [aws_subnet.public_subnet_01[0].id, aws_subnet.public_subnet_02[0].id, aws_subnet.private_subnet_01[0].id, aws_subnet.private_subnet_02[0].id])
}

output "security_groups" {
  description = "Security group for the cluster control plane communication with worker nodes"
  value = aws_security_group.control_plane.id
}

output "vpc_id" {
  description = "The VPC Id"
  value = aws_vpc.main.id
}

# Data source to fetch available availability zones
data "aws_availability_zones" "available" {}

# Provide values for variables
locals {
  stack_name = "YourStackName" # Replace with your stack name
}

