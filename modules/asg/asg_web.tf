resource "aws_autoscaling_group" "asg_web" {
  name                = var.asg_web_name
  desired_capacity    = 2
  min_size            = 2
  max_size            = 4
  target_group_arns   = [var.tg_web]
  health_check_type   = "EC2"
  vpc_zone_identifier = [var.web_subnet_ids["web_sub_1a"],
                        var.web_subnet_ids["web_sub_1b"]]



  launch_template {
    id      = aws_launch_template.template_web.id
    version = aws_launch_template.template_web.latest_version
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
}