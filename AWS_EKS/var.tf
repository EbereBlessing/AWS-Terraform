variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-2"
}
variable "cluster_name" {
  description = "cluster name"
  type        = string
  default     = "eks-project"
}
variable "vpc" {
  description = "EKS Project"
  type        = string
  default     = "EKS-VPC"
}

