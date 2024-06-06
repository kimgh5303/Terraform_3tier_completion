# public 라우트 테이블 리소스를 정의
resource "aws_route_table" "public-route-table" {
  vpc_id = aws_vpc.vpc.id                                # VPC의 ID를 참조

  # 라우트 규칙을 정의. 모든 인터넷 트래픽(0.0.0.0/0)을 인터넷 게이트웨이로 보냄
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet-gw.id
  }

  tags = {
    Name = var.public-rt-name
    Owner = var.owner-tag
  }
}

# public 서브넷 1에 대한 라우트 테이블 연결을 정의
resource "aws_route_table_association" "pub-rt-asscociation-1" {
  subnet_id      = aws_subnet.public-subnet1.id
  route_table_id = aws_route_table.public-route-table.id
}

# public 서브넷 2에 대한 라우트 테이블 연결을 정의
resource "aws_route_table_association" "pub-rt-asscociation-2" {
  subnet_id      = aws_subnet.public-subnet2.id
  route_table_id = aws_route_table.public-route-table.id
}
