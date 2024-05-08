# Internet Gateway--------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}