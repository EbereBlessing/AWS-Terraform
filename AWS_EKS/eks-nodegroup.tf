resource "aws_eks_node_group" "eks_nodegroup" {
  cluster_name    = aws_eks_cluster.eks_project.name
  node_group_name = "EKS Node Group"
  node_role_arn   = aws_iam_role.worker_role.arn
  subnet_ids      =  local.subnets_ids

  scaling_config {
    desired_size = 2
    max_size     = 4
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
  depends_on = [
    aws_iam_role_policy_attachment.workernode_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.workernode_AmazonEC2ContainerRegistryReadOnly,
  ]
}