# VPC에 인터넷 게이트웨이 리소스를 생성
resource "aws_internet_gateway" "internet-gw" {
  vpc_id = aws_vpc.vpc.id           # VPC의 ID를 참조
  tags = {
    Name = var.igw-name
    Owner = var.owner-tag
  }
}
