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

  depends_on = [aws_lb.alb-web]

  tags = {
    Name = var.tg-web-name
    Owner = var.owner-tag
  }
}

# HTTPS 리스너 생성 - Target 그룹으로 포워딩
resource "aws_lb_listener" "myhttps-forward" {
  load_balancer_arn = aws_lb.alb-web.arn
  port              = 443
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.cert.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group-web.arn
  }

  tags = {
    Owner = var.owner-tag
  }

  depends_on = [aws_acm_certificate_validation.cert_val]
}

# HTTPS 리스너 규칙 생성
resource "aws_lb_listener_rule" "https-rule" {
  listener_arn = aws_lb_listener.myhttps-forward.arn
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

# HTTP redirection
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

#--------------------------------------------------------------------
# https 리다이렉션과 충돌하기 때문에 주석처리
/*
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
*/