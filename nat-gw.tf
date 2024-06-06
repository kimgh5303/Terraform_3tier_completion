# Elastic IP 1을 생성
resource "aws_eip" "eip" {
  domain = "vpc"                                      # EIP가 VPC 도메인에 연결되어야 함을 명시
}

# Elastic IP 2를생성
resource "aws_eip" "eip2" {
  domain = "vpc"                                      # EIP2가 VPC 도메인에 연결되어야 함을 명시
}

# NAT 게이트웨이 1을 정의
resource "aws_nat_gateway" "nat-gw" {
  allocation_id     = aws_eip.eip.id                  # EIP 1의 ID를 NAT 게이트웨이에 할당
  connectivity_type = "public"                        # NAT 게이트웨이의 연결 유형을 public으로 설정
  subnet_id         = aws_subnet.public-subnet1.id    # NAT 게이트웨이가 위치할 public 서브넷 1의 ID를 지정

  tags = {
    Name = var.nat-gw-name1
    Owner = var.owner-tag
  }

  depends_on = [aws_internet_gateway.internet-gw]     # NAT 게이트웨이 생성 전 인터넷 게이트웨이가 필요함을 명시
}

# NAT 게이트웨이 2를 정의
resource "aws_nat_gateway" "nat-gw2" {
  allocation_id     = aws_eip.eip2.id                 # EIP 2의 ID를 NAT 게이트웨이에 할당
  connectivity_type = "public"                        # NAT 게이트웨이의 연결 유형을 public으로 설정
  subnet_id         = aws_subnet.public-subnet2.id    # NAT 게이트웨이가 위치할 public 서브넷 2의 ID를 지정

  tags = {
    Name = var.nat-gw-name2
    Owner = var.owner-tag
  }

  depends_on = [aws_internet_gateway.internet-gw]     # NAT 게이트웨이 생성 전 인터넷 게이트웨이가 필요함을 명시
}
