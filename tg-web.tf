resource "aws_lb_target_group" "target-group-web" {
  name     = var.tg-web-name
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id
  health_check {
    path    = "/"
    matcher = "200-299"
    interval = 5
    timeout = 3
    healthy_threshold = 3
    unhealthy_threshold = 5

  }
}

# HTTPS 프로토콜을 사용하므로 이를 받아줄 리스너
# default action으로 404 페이지 출력
resource "aws_lb_listener" "myhttps" {
  load_balancer_arn = aws_lb.alb-web.arn
  port              = 443
  protocol          = "HTTPS"
 
  ssl_policy       = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.example.arn
 
  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      content_type = "text/plain"
      message_body = "404: page not found - BABO"
      status_code  = 404
    }
  }
}

# HTTPS 리스너 규칙 생성
# Target 그룹으로 포워딩
resource "aws_lb_listener_rule" "https-rule" {
  listener_arn = aws_lb_listener.myhttps.arn
  priority     = 100
 
  condition {
    path_pattern {
      values = ["*"]
    }
  }
 
  action {
    type = "forward"
    target_group_arn = aws_lb_target_group.target-group-web.arn
  }
}


# HTTP 프로토콜 리스너
# default action으로 404 페이지 출력
resource "aws_lb_listener" "myhttp" {
  load_balancer_arn = aws_lb.alb-web.arn
  port              = 80
  protocol          = "HTTP"

  # By default, return a simple 404 page
  default_action {
    type = "redirect"

    redirect {
      port = "443"
      protocol = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}
