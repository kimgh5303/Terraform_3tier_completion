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
