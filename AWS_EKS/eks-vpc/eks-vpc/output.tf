output "vpc_id" {
  value = aws_vpc.eks_vpc.id
}
output "public_subnets" {
  value =  [for subnet in aws_subnet.eks_public_subnet : subnet.id]
}
output "private_subnets" {
  value =  [for subnet in aws_subnet.eks_public_subnet : subnet.id]
}
