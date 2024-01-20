resource "aws_eks_cluster" "eks_project" {
  name     = "AWS EKS Project"
  role_arn = aws_iam_role.master_role.arn
 
  vpc_config {
    subnet_ids = local.subnets_ids
  }
  depends_on = [
    aws_iam_role_policy_attachment.masternode_AmazonEKSClusterPolicy
  ]
}