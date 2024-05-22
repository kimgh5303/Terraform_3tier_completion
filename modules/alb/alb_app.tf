resource "aws_lb" "alb_app" {
  name               = var.alb_app_name
  internal           = true
  load_balancer_type = "application"
  security_groups    = [var.alb_app_sg]
  subnets            = [var.app_subnet_ids["app_sub_1a"],
                        var.app_subnet_ids["app_sub_1c"]]

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}