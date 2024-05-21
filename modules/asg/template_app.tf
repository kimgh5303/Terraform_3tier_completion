/*
resource "aws_launch_template" "template_app" {
  name          = var.template_app_name
  image_id      = var.ami_id
  instance_type = var.instance_type

  # 인스턴스 안에서 메타데이터 사용 가능
  dynamic "metadata_options" {
    for_each = var.metadata_options

    content {
      http_endpoint               = metadata_options.value.http_endpoint
      http_tokens                 = metadata_options.value.http_tokens
      http_put_response_hop_limit = metadata_options.value.http_put_response_hop_limit
      instance_metadata_tags      = metadata_options.value.instance_metadata_tags
    }
  }

  network_interfaces {
    device_index    = 0
    security_groups = [var.alb_app_sg]
  }

  user_data = base64encode(templatefile("${path.module}/app_user_data.sh",{
    host = "${data.aws_db_instance.my_rds.endpoint}"
    rds_endpoint = "${data.aws_db_instance.my_rds.endpoint}"
    username = "${var.db_user.db_username}"
    password = "${var.db_user.db_password}"
    db = "${var.rds_db.db_name}"
  }))

  depends_on = [
    aws_db_instance.rds_db
  ]

  tag_specifications {
    resource_type = "instance"
    tags = {
      name                = var.asg_app_name
      key                 = var.tags.key
      value               = var.tags.value
    }
  }
}
*/