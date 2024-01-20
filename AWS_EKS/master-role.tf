data "aws_iam_policy_document" "master_assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "master_role" {
  name               = "eks-masternode-role"
  assume_role_policy = data.aws_iam_policy_document.master_assume_role.json
}

resource "aws_iam_role_policy_attachment" "masternode_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.master_role.name
}
