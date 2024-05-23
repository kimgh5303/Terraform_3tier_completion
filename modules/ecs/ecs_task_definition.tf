

#--------------------------------------------------------------------
# web task definition
resource "aws_ecs_task_definition" "web_task_def" {
  family                   = "kgh-web-service"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn

  requires_compatibilities = ["EC2"]

  runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }

  container_definitions = jsonencode([
    {
      name      = "web-nginx-container"
      image     = "381492154999.dkr.ecr.ap-northeast-2.amazonaws.com/frontend:latest"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
          protocol      = "tcp"
        }
      ],
      "essential": true,
      environment = [
        {
          name = "ALB"
          value = "${var.alb_app_dns}"
        }
      ],
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.az_1}, ${var.az_2}]"
  }

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}

# app task definition
resource "aws_ecs_task_definition" "app_task_def" {
  family                   = "kgh-app-service"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn

  requires_compatibilities = ["EC2"]

  runtime_platform {
   operating_system_family = "LINUX"
   cpu_architecture        = "X86_64"
 }

  container_definitions = jsonencode([
    {
      name      = "app-nginx-container"
      image     = "381492154999.dkr.ecr.ap-southeast-1.amazonaws.com/backend:latest"
      cpu       = 10
      memory    = 256
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 0
        }
      ],
      "essential": true,
      environment = [
      {name = "rds_endpoint", value = "${var.rds_endpoint}"},
      {name = "HOST", value = "${var.host}"},
      {name = "USERNAME", value = "${var.db_user.db_username}"},
      {name = "PASSWORD", value = "${var.db_user.db_password}"},
      {name = "DB", value = "${var.rds_db.db_name}"},
      ],
    }
  ])

  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.az_1}, ${var.az_2}]"
  }

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}