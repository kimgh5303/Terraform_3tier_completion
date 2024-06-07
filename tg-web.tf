resource "aws_lb_target_group" "target-group-web" {
  # 타겟 그룹을 생성하여 HTTP 트래픽을 처리
  # 로드 밸런서에서 웹 애플리케이션으로 트래픽을 정확히 라우팅할 수 있게함
  name     = var.tg-web-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id              # VPC의 ID를 지정

  # 로드 밸런서가 트래픽을 전달하기 전에 타겟의 상태를 주기적으로 검사
  # 서비스의 가용성을 유지하고 장애가 있는 서버를 트래픽에서 제외
  health_check {
    path    = "/"                        # Health Check 경로
    matcher = "200-299"                  # Health Check를 판단하는 HTTP 응답 코드 범위
    interval = 5                         # Health Check 반복 간격 (초)
    timeout = 3                          # Health Check 최대 대기 시간 (초)
    healthy_threshold = 3                # Healthy 판단을 위한 연속 성공 횟수
    unhealthy_threshold = 5              # UnHealthy 판단을 위한 실패 횟수
  }

  # 로드 밸런서 생성 후 타겟 그룹이 생성되도록 의존성 설정
  depends_on = [aws_lb.alb-web]

  tags = {
    Name = var.tg-web-name
    Owner = var.owner-tag
  }
}

# HTTPS 리스너 생성 - Target 그룹으로 포워딩
resource "aws_lb_listener" "myhttps-forward" {
  # HTTPS 리스너를 로드 밸런서에 연결하고 443 포트에서 HTTPS 트래픽을 받도록 설정
  # SSL 정책과 ACM 인증서를 사용하여 트래픽의 보안을 강화
  load_balancer_arn = aws_lb.alb-web.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  # 기본 동작은 HTTPS 트래픽을 지정된 타겟 그룹으로 포워딩
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-web.arn
  }

  tags = {
    Owner = var.owner-tag
  }

  # 인증서 검증이 완료된 후 리스너가 생성되도록 의존성 설정
  depends_on = [aws_acm_certificate_validation.cert_val]
}

# HTTPS 리스너 규칙 생성
resource "aws_lb_listener_rule" "https-rule" {
  # HTTPS 리스너에 대한 규칙을 생성, 모든 요청을 타겟 그룹으로 포워딩
  listener_arn = aws_lb_listener.myhttps-forward.arn
  priority     = 100

  # 조건: 모든 경로 패턴에 대해 적용
  condition {
    path_pattern {
      values = ["*"]
    }
  }

  # 동작: 트래픽을 타겟 그룹으로 포워딩
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target-group-web.arn
  }
}

# HTTP redirection
resource "aws_lb_listener" "http-redirection" {
  # HTTP 요청을 HTTPS로 리다이렉션하는 HTTP 리스너 설정
  load_balancer_arn = aws_lb.alb-web.arn
  port              = 80
  protocol          = "HTTP"

  # 기본 동작: HTTP 요청을 HTTPS로 301 리다이렉트
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}