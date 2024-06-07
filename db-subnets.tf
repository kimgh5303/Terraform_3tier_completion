resource "aws_subnet" "db-subnet1" {
  vpc_id                  = aws_vpc.vpc.id         # VPC의 ID를 지정
  cidr_block              = var.db-subnet1-cidr    # 서브넷의 CIDR 블록을 지정
  availability_zone       = var.az-1               # 서브넷이 위치할 가용 영역을 지정
  map_public_ip_on_launch = false
  # 인스턴스가 인터넷에서 직접 접근 가능한 공개 IP를 받지 않도록 함

  tags = {
    Name = var.db-subnet1-name
    Owner = var.owner-tag
  }
}

resource "aws_subnet" "db-subnet2" {
  vpc_id                  = aws_vpc.vpc.id         # VPC의 ID를 지정
  cidr_block              = var.db-subnet2-cidr    # 서브넷의 CIDR 블록을 지정
  availability_zone       = var.az-2               # 서브넷이 위치할 가용 영역을 지정
  map_public_ip_on_launch = false
  # 인스턴스가 인터넷에서 직접 접근 가능한 공개 IP를 받지 않도록 함

  tags = {
    Name = var.db-subnet2-name
    Owner = var.owner-tag
  }
}
