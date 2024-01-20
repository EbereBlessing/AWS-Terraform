variable "eks_cluster_name" {
  description = "The name of the EKS cluster"
  default = "EKS Cluster Project"
  type = string
}
variable "vpc_name" {
  type        = string
  default = "EKS vpc"
}

variable "route_table_name" {
  type        = string
  default     = "EKS main"
  description = "Route table description"
}

variable "vpc_cidr_block" {
  type        = string
  default     = "10.0.0.0/16"
  description = "CIDR block range for vpc"
}

variable "private_subnet_cidr_blocks" {
  type        = list(string)
  default     = ["10.0.0.0/24", "10.0.1.0/24"]
  description = "CIDR block range for the private subnet"
}

variable "public_subnet_cidr_blocks" {
  type = list(string)
  default     = ["10.0.2.0/24", "10.0.3.0/24"]
  description = "CIDR block range for the public subnet"
}

variable "private_subnet_name" {
  type        = string
  default = "EKS private subnet"
  description = "Name tag for the private subnet"
}

variable "public_subnet_name" {
  type        = string
  default = "EKS public subnet"
  description = "Name tag for the public subnet"
}

variable "az" {
  type  = list(string)
  default = ["us-east-2a", "us-east-2b", "us-east-2c"]
  description = "List of availability zones for the selected region"
}

variable "region" {
  default = ["us-east-2"]
  type        = string
}
locals {
  public_subnets_ids  = var.public_subnet_cidr_blocks
  private_subnets_ids = module.vpc.private_subnet_cidr_blocks
  subnets_ids         = concat(local.public_subnets_ids, local.private_subnets_ids)
  }