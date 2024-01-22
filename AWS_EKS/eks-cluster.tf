resource "aws_eks_cluster" "eks_project" {
  name     = "AWS_EKS_Project"
  role_arn = aws_iam_role.master_role.arn

  vpc_config {
    security_group_ids      = [aws_security_group.eks_cluster.id, aws_security_group.eks_nodes.id]
    endpoint_private_access = true
    endpoint_public_access  = true
    subnet_ids = var.subnet_ids
  }
  depends_on = [
    aws_iam_role_policy_attachment.masternode_AmazonEKSClusterPolicy
    modules.eks-vpc
  ]
}
