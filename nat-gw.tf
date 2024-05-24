resource "aws_eip" "eip" {
  domain = "vpc"
}

resource "aws_eip" "eip2" {
  domain = "vpc"
}

resource "aws_nat_gateway" "nat-gw" {
  allocation_id     = aws_eip.eip.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public-subnet1.id

  tags = {
    Name = var.nat-gw-name1
    Owner = var.owner-tag
  }

  depends_on = [aws_internet_gateway.internet-gw]
}

resource "aws_nat_gateway" "nat-gw2" {
  allocation_id     = aws_eip.eip2.id
  connectivity_type = "public"
  subnet_id         = aws_subnet.public-subnet2.id

  tags = {
    Name = var.nat-gw-name2
    Owner = var.owner-tag
  }

  depends_on = [aws_internet_gateway.internet-gw]
}