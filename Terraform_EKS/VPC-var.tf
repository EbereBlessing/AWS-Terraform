# Define variables

variable "region" {
  default = "us-east-1"
}
  
variable "vpc_block" {
  default     = "10.0.0.0/16"
  description = "CIDR block of the vpc"
}
variable "stack_name" {
   type    = string
  default = "EKS-setup"
}
variable "public_subnet_01_block" {
    default = "10.0.1.0/24"
    description = "CIDR block for Public Subnet"
}
variable "public_subnet_02_block" {
    default = "10.0.2.0/24"
    description = "CIDR block for Public Subnet"

}
variable "private_subnet_01_block" {
    default = "10.0.3.0/24"
    description = "CIDR block for Private Subnet"
}
variable "private_subnet_02_block" {
    default = "10.0.4.0/24"
    description = "CIDR block for Private Subnet"
}

