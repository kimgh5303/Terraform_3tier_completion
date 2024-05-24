resource "aws_launch_template" "template-web" {
  name          = var.launch-template-web-name
  image_id      = var.image-id
  instance_type = var.instance-type
  #key_name      = var.key-name

  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_instance_profile.arn
  }

  monitoring {
    enabled = true
  }

  lifecycle {
    create_before_destroy = true
  }

  # 인스턴스 안에서 메타데이터 사용가능
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.asg-security-group-web.id]
  }

  
  user_data = base64encode(templatefile("web-user-data.sh",{
    ecs-cluster-name = "${var.web-prefix}-${var.ecs-cluster-name}"

  }))

   depends_on = [
    aws_lb.alb-web
  ]

  tag_specifications {

    resource_type = "instance"
    tags = {
      Name = var.web-instance-name
      Owner = var.owner-tag
    }
  }
}

