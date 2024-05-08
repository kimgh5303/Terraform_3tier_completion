# VPC 모듈
# VPC-------------------------------------------
resource "aws_vpc" "vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = format("%s-vpc", var.tags.value)
    key                 = var.tags.key
    value               = var.tags.value
  }
}