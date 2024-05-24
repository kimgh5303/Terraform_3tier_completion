resource "aws_autoscaling_group" "asg-app" {
  name                = var.asg-app-name
  desired_capacity    = 2
  max_size            = 5
  min_size            = 2
  target_group_arns   = [aws_lb_target_group.target-group-app.arn]
  health_check_type   = "EC2"
  vpc_zone_identifier = [aws_subnet.app-subnet1.id, aws_subnet.app-subnet2.id]
  
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }


  launch_template {
    id      = aws_launch_template.template-app.id
    version = aws_launch_template.template-app.latest_version
    
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

  # 인스턴스 보호 설정(scale-in) # 필요시 끄세요
  protect_from_scale_in = false
}

