# 베스천 호스트 인스턴스 생성
resource "aws_instance" "bastion" {
  ami           = var.bastion-image-id
  instance_type = var.bastion-instance-type
  subnet_id     = aws_subnet.public-subnet1.id
  vpc_security_group_ids = [aws_security_group.bastion_sg.id]

  key_name = aws_key_pair.deployer.key_name

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