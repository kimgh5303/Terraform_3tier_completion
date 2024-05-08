resource "aws_eip" "eip" {
  domain = "vpc"
  tags = {
    Name = format("%s-eip-1", var.tags["name"])
  }
}

resource "aws_eip" "eip2" {
  domain = "vpc"
  tags = {
    Name = format("%s-eip-2", var.tags["name"])
  }
}

locals {
  nat_gateways = {
    "ngw-1a" = {
      allocation_id = aws_eip.eip.id
      subnet_id     = aws_subnet.public_subnets["pub_sub_1a"].id
    },
    "ngw-1b" = {
      allocation_id = aws_eip.eip2.id
      subnet_id     = aws_subnet.public_subnets["pub_sub_1b"].id
    }
  }
}

resource "aws_nat_gateway" "ngw" {
  for_each          = local.nat_gateways

  allocation_id     = each.value.allocation_id
  connectivity_type = "public"
  subnet_id         = each.value.subnet_id

  tags = {
    Name = format("%s-%s", var.tags["name"], each.key)
  }

  depends_on = [aws_internet_gateway.igw]
}