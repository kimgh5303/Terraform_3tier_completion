resource "aws_lb_target_group" "tg_web" {
  name     = var.tg_web_name
  port     = 80
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  dynamic "health_check" {
    for_each = var.health_checks

    content {
      path                 = health_check.value.path
      matcher              = health_check.value.matcher
      interval             = health_check.value.interval
      timeout              = health_check.value.timeout
      healthy_threshold    = health_check.value.healthy_threshold
      unhealthy_threshold  = health_check.value.unhealthy_threshold
    }
  }

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}

resource "aws_lb_listener" "listener_http_web" {
  load_balancer_arn = aws_lb.alb_web.arn
  port     = 80
  protocol = "HTTP"

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

resource "aws_lb_listener_rule" "listener_rule_http_web" {
  listener_arn = aws_lb_listener.listener_http_web.arn
  priority     = 100

  condition {
    path_pattern {
      values = ["*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_web.arn
  }
}