terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
resource "aws_eks_cluster" "eks-project" {
  name     = "AWS EKS Project"
  role_arn = aws_iam_role.master-role.arn
  cluster_endpoint_public_access = true

  vpc_config {
    subnet_ids = local.subnets_ids
  }
  depends_on = [
    aws_iam_role_policy_attachment.masternode-AmazonEKSClusterPolicy
  ]
}