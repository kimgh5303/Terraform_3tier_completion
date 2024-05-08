locals {
  private_rt = {
    "pri-rt-1" = {
      gateway_id = aws_nat_gateway.ngw["ngw-1a"].id
    },
    "pri-rt-2" = {
      gateway_id = aws_nat_gateway.ngw["ngw-1b"].id
    }
  }
}

# private subnet - route table 정의
locals {
  subnet_to_rt = {
    "web_sub_1a" = "pri-rt-1",
    "web_sub_1b" = "pri-rt-2",
    "app_sub_1a" = "pri-rt-1",
    "app_sub_1b" = "pri-rt-2"
  }
}

resource "aws_route_table" "private_rt" {
  for_each = local.private_rt
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = var.rt_cidr_blocks
    gateway_id = each.value.gateway_id
  }

  tags = {
    Name = format("%s-%s", var.tags["name"], each.key)
  }
}

resource "aws_route_table_association" "web_rt_association" {
  for_each = aws_subnet.web_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt[local.subnet_to_rt[each.key]].id
}

resource "aws_route_table_association" "app_rt_association" {
  for_each = aws_subnet.app_subnets

  subnet_id      = each.value.id
  route_table_id = aws_route_table.private_rt[local.subnet_to_rt[each.key]].id
}