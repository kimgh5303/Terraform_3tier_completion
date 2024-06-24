# AWS VPC 리소스 정의
resource "aws_vpc" "vpc" {
  cidr_block = var.vpc-cidr-block
  enable_dns_support = true             # DNS 지원 활성화 설정
  enable_dns_hostnames = true           # DNS 호스트네임 활성화 설정
  tags = {
    Name = var.vpc-name
    Owner = var.owner-tag
  }
}
