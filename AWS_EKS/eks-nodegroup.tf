resource "aws_eks_node_group" "eks-nodegroup" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "EKS Node Group"
  node_role_arn   = aws_iam_role.worker-role.arn
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
    aws_iam_role_policy_attachment.workernode-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.workernode-AmazonEC2ContainerRegistryReadOnly,
  ]
}