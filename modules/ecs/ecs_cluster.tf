# Web ecs cluster
resource "aws_ecs_cluster" "web_ecs_cluster" {
  name = "kgh-web-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}

# App ecs cluster
resource "aws_ecs_cluster" "app_ecs_cluster" {
  name = "kgh-app-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}




# web task definition
resource "aws_ecs_task_definition" "web_task_def" {
  family                   = "web-service"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_service_role.arn
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["EC2"]
  container_definitions    = data.template_file.web_service.rendered
  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}

# app task definition
resource "aws_ecs_task_definition" "app_task_def" {
  family                   = "app-service"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_service_role.arn
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["EC2"]
  container_definitions    = data.template_file.web_service.rendered
  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}
