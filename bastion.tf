# 베스천 호스트 인스턴스 생성
resource "aws_instance" "bastion" {
  ami           = var.bastion-image-id            # 베스천 호스트에 사용될 AMI ID
  instance_type = var.bastion-instance-type       # 인스턴스 유형
  subnet_id     = aws_subnet.public-subnet1.id    # 베스천 호스트가 위치할 퍼블릭 서브넷 ID

  # 인스턴스에 적용할 보안 그룹 ID 목록
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]   # 베스천 호스트용 보안 그룹

  key_name = aws_key_pair.deployer.key_name       # SSH 접속에 사용될 키 페어의 이름

  tags = {
    Name = "bastion"
    Owner = var.owner-tag
  }
}

# 베스천 호스트 보안 그룹
resource "aws_security_group" "bastion_sg" {
  vpc_id = aws_vpc.vpc.id                   # VPC의 ID를 지정

  # 베스천 호스트로 들어오는 SSH 트래픽을 허용
  ingress {
    from_port   = 22                        # SSH 포트 22에서 트래픽 시작
    to_port     = 22                        # SSH 포트 22에서 트래픽 종료
    protocol    = "tcp"                     # TCP 프로토콜 사용
    cidr_blocks = ["0.0.0.0/0"]             # 모든 IP 범위에서 접근 허용
  }

  egress {
    from_port   = 0                         # 모든 포트에서 시작
    to_port     = 0                         # 모든 포트에서 종료
    protocol    = "-1"                      # 모든 프로토콜 포함
    cidr_blocks = ["0.0.0.0/0"]             # 모든 IP 범위로 접근 허용
  }

  tags = {
    Name  = "bastion-sg"
    Owner = var.owner-tag
  }
}