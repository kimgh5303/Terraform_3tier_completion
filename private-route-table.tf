resource "aws_route_table" "private-route-table1" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw.id
  }

  tags = {
    Name = var.private-rt-name1
    Owner = var.owner-tag
  }
}

resource "aws_route_table" "private-route-table2" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.nat-gw2.id
  }

  tags = {
    Name = var.private-rt-name2
    Owner = var.owner-tag
  }
}

# WEB
resource "aws_route_table_association" "pri-rt-asscociation-1" {
  subnet_id      = aws_subnet.web-subnet1.id
  route_table_id = aws_route_table.private-route-table1.id
}

resource "aws_route_table_association" "pri-rt-asscociation-2" {
  subnet_id      = aws_subnet.web-subnet2.id
  route_table_id = aws_route_table.private-route-table2.id
}

# WAS
resource "aws_route_table_association" "pri-rt-asscociation-3" {
  subnet_id      = aws_subnet.app-subnet1.id
  route_table_id = aws_route_table.private-route-table1.id
}

resource "aws_route_table_association" "pri-rt-asscociation-4" {
  subnet_id      = aws_subnet.app-subnet2.id
  route_table_id = aws_route_table.private-route-table2.id
}