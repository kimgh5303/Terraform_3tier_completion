resource "aws_lb_target_group" "target-group-app" {
  name     = var.tg-app-name
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

  tags = {
    Name = var.tg-app-name
    Owner = var.owner-tag
  }
}

resource "aws_lb_listener" "alb_listener-app" {
  load_balancer_arn = aws_lb.alb-app.arn
  port              = "80"
  protocol          = "HTTP"

  # 기본 동작은 트래픽을 지정된 타겟 그룹으로 포워딩
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-app.arn
  }

  # 로드 밸런서 생성 후 타겟 그룹이 생성되도록 의존성 설정
  depends_on = [aws_lb.alb-app]

  tags = {
    Owner = var.owner-tag
  }
}
