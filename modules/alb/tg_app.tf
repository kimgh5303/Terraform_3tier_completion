resource "aws_lb_target_group" "tg_app" {
  name     = var.tg_app_name
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

resource "aws_lb_listener" "listener_http_app" {
  load_balancer_arn = aws_lb.alb_app.arn
  port     = 80
  protocol = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_app.arn
  }
}