# App Application Load Balancer (ALB)를 위한 보안 그룹을 생성
resource "aws_security_group" "alb-security-group-app" {
  name        = var.alb-sg-app-name
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc.id                  # VPC의 ID를 지정

  ingress {
    description     = "HTTP from Internet"
    from_port       = 80                        # HTTP 포트 80에서 트래픽 시작
    to_port         = 80                        # HTTP 포트 80에서 트래픽 종료
    protocol        = "tcp"                     # TCP 프로토콜 사용
    security_groups = [aws_security_group.asg-security-group-web.id]
    # ASG의 보안 그룹 ID를 참조하여 해당 그룹으로부터만 트래픽 허용
  }

  egress {
    from_port   = 0                         # 모든 포트에서 시작
    to_port     = 0                         # 모든 포트에서 종료
    protocol    = "-1"                      # 모든 프로토콜 포함
    cidr_blocks = ["0.0.0.0/0"]             # 모든 IP 범위로 접근 허용
  }

  tags = {
    Name = var.alb-sg-app-name
    Owner = var.owner-tag
  }
}
