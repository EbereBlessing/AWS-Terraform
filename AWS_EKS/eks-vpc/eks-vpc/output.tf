output "vpc_id" {
  value = aws_vpc.eks_vpc.endpoint
}
output "public_subnets" {
  value = aws_subnet.eks_public_subnet.endpoint
}
output "private_subnets" {
  value = aws_subnet.eks_public_subnet.endpoint
}