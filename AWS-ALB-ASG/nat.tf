# nat.tf
# EIP
resource "aws_eip" "NAT_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}
# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.NAT_eip.id
  subnet_id     = aws_subnet.public_subnet2.id
  depends_on = [aws_eip.NAT_eip]
  tags = {
    Name  = "nat-gateway-${var.tag}"
  }
}
resource "aws_eip_association" "ec2-bastion-host-eip-association" {
    instance_id = aws_instance.public_ec2.id
    allocation_id = aws_eip.NAT_eip.id
}