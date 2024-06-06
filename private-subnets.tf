# web 서브넷 1 리소스를 VPC 내에 정의
resource "aws_subnet" "web-subnet1" {
  vpc_id                  = aws_vpc.vpc.id            # VPC의 ID를 참조
  cidr_block              = var.web-subnet1-cidr      # web 서브넷 1의 CIDR 블록을 설정
  availability_zone       = var.az-1                  # 서브넷이 위치할 가용 영역을 설정
  map_public_ip_on_launch = false                     # 공용 IP 주소 매핑 비활성화

  tags = {
    Name = var.web-subnet1-name
    Owner = var.owner-tag
  }
}

# web 서브넷 2 리소스를 VPC 내에 정의
resource "aws_subnet" "web-subnet2" {
  vpc_id                  = aws_vpc.vpc.id            # VPC의 ID를 참조
  cidr_block              = var.web-subnet2-cidr      # web 서브넷 2의 CIDR 블록을 설정
  availability_zone       = var.az-2                  # 서브넷이 위치할 가용 영역을 설정
  map_public_ip_on_launch = false                     # 공용 IP 주소 매핑 비활성화

  tags = {
    Name = var.web-subnet2-name
    Owner = var.owner-tag
  }
}

# app 서브넷 1 리소스를 VPC 내에 정의
resource "aws_subnet" "app-subnet1" {
  vpc_id                  = aws_vpc.vpc.id            # VPC의 ID를 참조
  cidr_block              = var.app-subnet1-cidr      # app 서브넷 1의 CIDR 블록을 설정
  availability_zone       = var.az-1                  # 서브넷이 위치할 가용 영역을 설정
  map_public_ip_on_launch = false                     # 공용 IP 주소 매핑 비활성화

  tags = {
    Name = var.app-subnet1-name
    Owner = var.owner-tag
  }
}

# app 서브넷 2 리소스를 VPC 내에 정의
resource "aws_subnet" "app-subnet2" {
  vpc_id                  = aws_vpc.vpc.id            # VPC의 ID를 참조
  cidr_block              = var.app-subnet2-cidr      # app 서브넷 2의 CIDR 블록을 설정
  availability_zone       = var.az-2                  # 서브넷이 위치할 가용 영역을 설정
  map_public_ip_on_launch = false                     # 공용 IP 주소 매핑 비활성화

  tags = {
    Name = var.app-subnet2-name
    Owner = var.owner-tag
  }
}