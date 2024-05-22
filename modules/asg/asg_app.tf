resource "aws_autoscaling_group" "asg_app" {
  name                = var.asg_app_name
  desired_capacity    = 2
  max_size            = 4
  min_size            = 2
  target_group_arns   = [var.tg_web]
  health_check_type   = "EC2"
  vpc_zone_identifier = [var.app_subnet_ids["app_sub_1a"],
                        var.app_subnet_ids["app_sub_1c"]]

  launch_template {
    id      = aws_launch_template.template_app.id
    version = aws_launch_template.template_app.latest_version
  }

  tag {
    key                 = var.tags.key
    value               = var.tags.value
    propagate_at_launch = true
  }
  
  instance_refresh {
    strategy = "Rolling"
    preferences {
      min_healthy_percentage = 50
    }
    triggers = ["tag"]
  }

  lifecycle {
    create_before_destroy = true
  }
}