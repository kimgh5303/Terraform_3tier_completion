# Public Subnets--------------------------------
resource "aws_subnet" "public_subnets" {
  for_each          = var.public_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value.cidr
  availability_zone = each.value.zone

  tags = {
    Name = format("%s-pub-sub-%s", var.tags["name"], element(split("_", each.key), 2))
  }
}

# Web Subnets--------------------------------
resource "aws_subnet" "web_subnets" {
  for_each          = var.web_subnets

  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["zone"]

  tags = merge(
    {
      Name = format(
        "%s-web-sub-%s",
        var.tags["name"],
        element(split("_", each.key), 2)
      )
    },
    var.tags,
  )
}

# App Subnets--------------------------------
resource "aws_subnet" "app_subnets" {
  for_each          = var.app_subnets
  
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["zone"]

  tags = merge(
    {
      Name = format(
        "%s-app-sub-%s",
        var.tags["name"],
        element(split("_", each.key), 2)
      )
    },
    var.tags,
  )
}

# DB Subnets---------------------------------
resource "aws_subnet" "db_subnets" {
  for_each          = var.db_subnets
  
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = each.value["cidr"]
  availability_zone = each.value["zone"]
  map_public_ip_on_launch = each.value["map_public_ip_on_launch"]

  tags = merge(
    {
      Name = format(
        "%s-db-sub-%s",
        var.tags["name"],
        element(split("_", each.key), 2)
      )
    },
    var.tags,
  )
}

# DB Subnet group----------------------------
resource "aws_db_subnet_group" "db_subnet_grp" {
  subnet_ids = [aws_subnet.db_subnets["db_sub_1a"].id,aws_subnet.db_subnets["db_sub_1b"].id]

  tags = {
    Name = format("%s-db-sub-grp", var.tags["name"])
  }
}