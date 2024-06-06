# Web Application Load Balancer (ALB)를 위한 보안 그룹을 생성
resource "aws_security_group" "alb-security-group-web" {
  name        = var.alb-sg-web-name
  description = "ALB Security Group"
  vpc_id      = aws_vpc.vpc.id              # VPC의 ID를 지정

  # 인터넷에서 ALB로 들어오는 HTTP 트래픽을 80번 포트에서만 허용하도록 제한
  ingress {
    description = "HTTP from Internet"
    from_port   = 80                        # HTTP 포트 80에서 트래픽 시작
    to_port     = 80                        # HTTP 포트 80에서 트래픽 종료
    protocol    = "tcp"                     # TCP 프로토콜 사용
    cidr_blocks = ["0.0.0.0/0"]             # 모든 IP 범위에서 접근 허용
  }

  # 인터넷에서 ALB로 들어오는 HTTPS 트래픽을 443번 포트에서만 허용하도록 제한
  ingress {
    description = "HTTPS from Internet"
    from_port   = 443                       # HTTPS 포트 443에서 트래픽 시작
    to_port     = 443                       # HTTPS 포트 443에서 트래픽 종료
    protocol    = "tcp"                     # TCP 프로토콜 사용
    cidr_blocks = ["0.0.0.0/0"]             # 모든 IP 범위에서 접근 허용
  }

  # ALB에서 인터넷으로 모든 종류의 아웃바운드 트래픽을 허용하는 규칙을 정의
  egress {
    from_port   = 0                         # 모든 포트에서 시작
    to_port     = 0                         # 모든 포트에서 종료
    protocol    = "-1"                      # 모든 프로토콜 포함
    cidr_blocks = ["0.0.0.0/0"]             # 모든 IP 범위로 접근 허용
  }

  tags = {
    Name = var.alb-sg-web-name
    Owner = var.owner-tag
  }
}
