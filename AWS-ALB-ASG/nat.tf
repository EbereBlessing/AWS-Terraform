# Elastic-IP (eip) for NAT
resource "aws_eip" "NAT_eip" {
  vpc        = true
  depends_on = [aws_internet_gateway.igw]
}

# NAT Gateway
resource "aws_nat_gateway" "nat" {
  allocation_id = aws_eip.NAT_eip.id
  subnet_id     = element(aws_subnet.public_subnet.*.id, 0)
  depends_on = [aws_eip.NAT_eip]
  tags = {
    Name  = "nat-gateway-${var.tag}"
  }
}