variable "region" {
  default = "us-east-1"
}
variable "tag" {
  default = "vpc-setup"
}
variable "vpc_cidr" {
  default     = "10.0.0.0/16"
  description = "CIDR block of the vpc"
}
variable "public_subnets_cidr" {
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
  description = "CIDR block for Public Subnet"
}
variable "private_subnets_cidr" {
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
  description = "CIDR block for Private Subnet"
}
variable "private_AZ" {
    type    = list(string)
    default = ["us-east-1a"]
}
variable "public_AZ" {
    type    = list(string)
    default = ["us-east-1b"]
}
variable "os" {
    default = "ami-08a52ddb321b32a8c"
}
variable "instance" {
    default = "t2.micro"
}