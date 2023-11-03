variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}
variable "cluster_name" {
  description = "cluster name"
  type        = string
  default     = "EKS-SETUP"
}
variable "vpc" {
  description = "cluster name"
  type        = string
  default     = "EKS-VPC"
}

