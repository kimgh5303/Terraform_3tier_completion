# Public Route Table-------------------------------------
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.rt_cidr_blocks
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = format("%s-pub-rt", var.tags.value)
  }
}

resource "aws_route_table_association" "pub_rt_association" {
  for_each = aws_subnet.public_subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.public_rt.id
}