# Web AutoScaling (ASG)을 위한 보안 그룹을 생성
resource "aws_security_group" "asg-security-group-web" {
  name        = var.asg-sg-web-name
  description = "ASG Security Group"
  vpc_id      = aws_vpc.vpc.id              # VPC의 ID를 지정

  # ALB에서 들어오는 HTTP 트래픽을 80번 포트에서만 허용
  ingress {
    description     = "HTTP from ALB"
    from_port       = 80                    # HTTP 포트 80에서 트래픽 시작
    to_port         = 80                    # HTTP 포트 80에서 트래픽 종료
    protocol        = "tcp"                 # TCP 프로토콜 사용
    security_groups = [aws_security_group.alb-security-group-web.id]
    # ALB의 보안 그룹 ID를 참조하여 해당 그룹으로부터만 트래픽 허용
  }

  # ALB에서 들어오는 HTTP 트래픽을 1024~65535 포트 범위에서 허용.
  # 동적 포트 할당으로 컨테이너 태스크 포트 충돌 방지
  ingress {
    description     = "HTTP from ALB"
    from_port       = 1024                  # 동적 포트 할당 시작
    to_port         = 65535                 # 동적 포트 할당 종료
    protocol        = "tcp"                 # TCP 프로토콜 사용
    security_groups = [aws_security_group.alb-security-group-web.id]
    # ALB의 보안 그룹 ID를 참조하여 해당 그룹으로부터만 트래픽 허용
  }

  egress {
    from_port   = 0                         # 모든 포트에서 시작
    to_port     = 0                         # 모든 포트에서 종료
    protocol    = "-1"                      # 모든 프로토콜 포함
    cidr_blocks = ["0.0.0.0/0"]             # 모든 IP 범위로 접근 허용
  }

  tags = {
    Name = var.asg-sg-web-name
    Owner = var.owner-tag
  }
}
