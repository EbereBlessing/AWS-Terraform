# Route tables, route and route table association for the Private subnets
#Route for the private subnet
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id             = aws_nat_gateway.nat.id
}
# Route tables  for Private Subnet
resource "aws_route_table" "private-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name  = "${var.tag}-private-route-table"
  }
}
# Route table associations for both Private subnet 1
resource "aws_route_table_association" "private1" {
  subnet_id      = aws_subnet.private_subnet1.id
  route_table_id = aws_route_table.private-route_table.id
}
# Route table associations for both Private subnet 2
resource "aws_route_table_association" "private2" {
  subnet_id      = aws_subnet.private_subnet2.id
  route_table_id = aws_route_table.private-route_table.id
}



# Route tables, route and route table association for the Public subnets
# Route for the public subnet
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name  = "${var.tag}-public-route-table"
  }
}
#Route for the public subnet
resource "aws_route" "public_igw_gateway" {
  route_table_id         = aws_route_table.public-route-table.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.igw.id
}
# Route table associations for both Public subnet 1
resource "aws_route_table_association" "public1" {
  subnet_id      = aws_subnet.public_subnet1.id
  route_table_id = aws_route_table.public-route_table.id
}
# Route table associations for both Public subnet 2
resource "aws_route_table_association" "public2" {
  subnet_id      = aws_subnet.public_subnet2.id
  route_table_id = aws_route_table.public-route_table.id
}









