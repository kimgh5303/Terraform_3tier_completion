resource "aws_security_group" "asg-security-group-app" {
  name        = var.asg-sg-app-name
  description = "ASG Security Group"
  vpc_id      = aws_vpc.vpc.id              # VPC의 ID를 지정

  ingress {
    description     = "HTTP from ALB"
    from_port       = 1024                  # 동적 포트 할당 시작
    to_port         = 65535                 # 동적 포트 할당 종료
    protocol        = "tcp"                 # TCP 프로토콜 사용
    security_groups = [aws_security_group.alb-security-group-app.id]
  }

  egress {
    from_port   = 0                         # 모든 포트에서 시작
    to_port     = 0                         # 모든 포트에서 종료
    protocol    = "-1"                      # 모든 프로토콜 포함
    cidr_blocks = ["0.0.0.0/0"]             # 모든 IP 범위로 접근 허용
  }

  tags = {
    Name = var.asg-sg-app-name
    Owner = var.owner-tag
  }
}
