# Internet Gateway--------------------------------
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = format(
      "%s-igw",
      var.tags.value
    )
    key                 = var.tags.key
    value               = var.tags.value
  }
}