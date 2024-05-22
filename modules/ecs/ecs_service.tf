# web service
resource "aws_ecs_service" "web_ecs_service" {
  name            = "kgh-web-ecs-service"
  iam_role        = aws_iam_role.ecs_task_execution_role.name
  cluster         = aws_ecs_cluster.web_ecs_cluster.id
  task_definition = aws_ecs_task_definition.web_task_def.arn
  desired_count   = 6
  
  depends_on = [aws_ecs_task_definition.web_task_def,aws_ecs_cluster.web_ecs_cluster]
 
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  load_balancer {
    target_group_arn = var.tg_web
    container_name   = "web-nginx-container"
    container_port   = 80
  }
  
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone == ${var.az_1} || attribute:ecs.availability-zone == ${var.az_2}"
  }

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}

# app service
resource "aws_ecs_service" "app_ecs_service" {
  name            = "kgh-app-ecs-service"
  iam_role        = aws_iam_role.ecs_task_execution_role.name
  cluster         = aws_ecs_cluster.web_ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_task_def.arn
  desired_count   = 6
 
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone == ${var.az_1} || attribute:ecs.availability-zone == ${var.az_2}"
  }

  load_balancer {
    target_group_arn = var.tg_app
    container_name   = "app-container"
    container_port   = 8080
  }
  
  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}