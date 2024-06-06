resource "aws_security_group" "db-sg" {
  name        = var.db-sg-name
  description = "DB SEcurity Group"
  vpc_id      = aws_vpc.vpc.id

  ingress {
    from_port       = 3306                  # DB 포트 3306에서 트래픽 시작
    to_port         = 3306                  # DB 포트 3306에서 트래픽 종료
    protocol        = "tcp"                 # TCP 프로토콜 사용
    security_groups = [aws_security_group.asg-security-group-app.id,aws_security_group.bastion_sg.id]
    # ASG, Bastion의 보안 그룹 ID를 참조하여 해당 그룹으로부터만 트래픽 허용
  }

  egress {
    from_port   = 0                         # 모든 포트에서 시작
    to_port     = 0                         # 모든 포트에서 종료
    protocol    = "-1"                      # 모든 프로토콜 포함
    cidr_blocks = ["0.0.0.0/0"]             # 모든 IP 범위로 접근 허용
  }

  tags = {
    Name = var.db-sg-name
    Owner = var.owner-tag
  }
}
