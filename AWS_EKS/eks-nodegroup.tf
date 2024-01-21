# Nodes in private subnets
resource "aws_eks_node_group" "private" {
  cluster_name    = aws_eks_cluster.eks_project.name
  node_group_name = "eks_private_node"
  node_role_arn   = aws_iam_role.worker_role.arn
  subnet_ids      = var.private_subnet_ids

  ami_type       = var.ami_type
  disk_size      = var.disk_size
  instance_types = var.instance_types

  scaling_config {
    desired_size = var.private_desired_size
    max_size     = var.private_max_size
    min_size     = var.private_min_size
  }

  tags = {
    Name = "eks_private_node"
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.workernode_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.workernode_AmazonEC2ContainerRegistryReadOnly,
  ]
}

# Nodes in public subnet
resource "aws_eks_node_group" "public" {
  cluster_name    = aws_eks_cluster.eks_project.name
  node_group_name = "eks_public_node"
  node_role_arn   = aws_iam_role.worker_role.arn
  subnet_ids      = var.public_subnet_ids

  ami_type       = var.ami_type
  disk_size      = var.disk_size
  instance_types = var.instance_types

  scaling_config {
    desired_size = var.public_desired_size
    max_size     = var.public_max_size
    min_size     = var.public_min_size
  }

  tags = {
    Name = "eks_public_node"
  }

  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.workernode_AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.aws_eks_cni_policy,
    aws_iam_role_policy_attachment.workernode_AmazonEC2ContainerRegistryReadOnly,
  ]
}