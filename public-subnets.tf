# public 서브넷 리소스를 정의
resource "aws_subnet" "public-subnet1" {
  vpc_id                  = aws_vpc.vpc.id              # VPC의 ID를 참조
  cidr_block              = var.public-subnet1-cidr     # public 서브넷 1의 CIDR 블록을 설정
  availability_zone       = var.az-1                    # 서브넷이 위치할 가용 영역을 설정
  map_public_ip_on_launch = true                        # 공용 IP 주소 매핑 활성화

  tags = {
    Name = var.public-subnet1-name
    Owner = var.owner-tag
  }
}

resource "aws_subnet" "public-subnet2" {
  vpc_id                  = aws_vpc.vpc.id              # VPC의 ID를 참조
  cidr_block              = var.public-subnet2-cidr     # public 서브넷 2의 CIDR 블록을 설정
  availability_zone       = var.az-2                    # 서브넷이 위치할 가용 영역을 설정
  map_public_ip_on_launch = true                        # 공용 IP 주소 매핑 활성화

  tags = {
    Name = var.public-subnet2-name
    Owner = var.owner-tag
  }
}
