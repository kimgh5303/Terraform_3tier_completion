resource "aws_ecs_cluster" "ecs-cluster-web" {
  name = "${var.web-prefix}-${var.ecs-cluster-name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.web-prefix}-${var.ecs-cluster-name}"
    Owner = var.owner-tag
  }
}

resource "aws_ecs_cluster" "ecs-cluster-app" {
  name = "${var.app-prefix}-${var.ecs-cluster-name}"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  lifecycle {
    create_before_destroy = true
  }

  tags = {
    Name = "${var.app-prefix}-${var.ecs-cluster-name}"
    Owner = var.owner-tag
  }
}