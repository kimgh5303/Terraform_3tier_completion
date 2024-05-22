resource "aws_lb" "alb_web" {
  name               = var.alb_web_name
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_web_sg]
  subnets            = [var.public_subnet_ids["pub_sub_1a"],
                        var.public_subnet_ids["pub_sub_1c"]]

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}