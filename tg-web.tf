resource "aws_lb_target_group" "target-group-web" {
  name     = var.tg-web-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
/*
  stickiness {
    type         = "lb_cookie"  # 스티키 세션의 유형을 지정합니다. "lb_cookie" 또는 "app_cookie" 중 하나를 선택할 수 있습니다.
    cookie_duration = 3600       # 스티키 세션의 지속 시간을 설정합니다. (초 단위)
  }
*/
  health_check {
    path    = "/"
    matcher = "200-299"
    interval = 5
    timeout = 3
    healthy_threshold = 3
    unhealthy_threshold = 5

  }

  depends_on = [aws_lb.alb-web]

  tags = {
    Name = var.tg-web-name
    Owner = var.owner-tag
  }
}


# HTTPS 프로토콜을 사용하므로 이를 받아줄 리스너
# default action으로 404 페이지 출력

/*
resource "aws_lb_listener" "myhttps-redirection" {
  load_balancer_arn = aws_lb.alb-web.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.alb-cert.arn

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [aws_acm_certificate_validation.cert]

  tags = {
    Owner = var.owner-tag
  }
}

resource "aws_lb_listener" "myhttps-forward" {
  load_balancer_arn = aws_lb.alb-web.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.alb-cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-web.arn
  }

  tags = {
    Owner = var.owner-tag
  }
}


# HTTPS 리스너 규칙 생성
# Target 그룹으로 포워딩
resource "aws_lb_listener" "http-redirection" {
  load_balancer_arn = aws_lb.alb-web.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
*/

# HTTP 프로토콜 리스너
# default action으로 404 페이지 출력

resource "aws_lb_listener" "myhttp" {
  load_balancer_arn = aws_lb.alb-web.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-web.arn
  }

  tags = {
    Owner = var.owner-tag
  }
}