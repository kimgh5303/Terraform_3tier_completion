resource "aws_launch_template" "template-app" {
  name          = var.launch-template-app-name
  image_id      = var.image-id
  instance_type = var.instance-type
  #key_name      = var.key-name
  
  #iam_instance_profile {
  #  name = aws_iam_instance_profile.asg_instance_profile.name
  #}

  network_interfaces {
    device_index    = 0
    security_groups = [aws_security_group.asg-security-group-app.id]
    
  }

 # 인스턴스 안에서 메타데이터 사용가능
  metadata_options {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }


  user_data = base64encode(templatefile("app-user-data.sh",{
    host = "${local.host}"
    rds_endpoint = "${data.aws_db_instance.my_rds.endpoint}"
    username = "${var.db-username}"
    password = "${var.db-password}"
    db = "${var.db-name}"
  }))

   depends_on = [
    aws_db_instance.rds-db
  ]


  tag_specifications {

    resource_type = "instance"
    tags = {
      Name = var.app-instance-name
    }
  }
}


locals {
  rds_endpoint = "${data.aws_db_instance.my_rds.endpoint}"
  host = replace(local.rds_endpoint, ":3306", "")
}