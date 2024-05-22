data "template_file" "web_service" {
  template = file("${path.module}/web_service.config.json.tpl")
  vars = {
    region             = var.region
    aws_ecr_repository = aws_ecr_repository.repo.repository_url
    tag                = "latest"
    container_port     = 80
    host_port          = 80
    protocol           = "tcp"
  }
}


data "template_file" "app_service" {
  template = file("${path.module}/app_service.config.json.tpl")
  vars = {
    region             = var.region
    aws_ecr_repository = aws_ecr_repository.repo.repository_url
    tag                = "latest"
    container_port     = 8080
    host_port          = 8080
    protocol           = "tcp"
  }
}

# web service
resource "aws_ecs_service" "web_service" {
  iam_role        = aws_iam_role.ecs_service_role.name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.web_task_def.arn
  launch_type     = "EC2"
  desired_count   = 3
  
 
  network_configuration {
    security_groups  = [aws_security_group.ecs_node_sg.id]
    subnets          = var.web_subnet_ids[*]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.tg_web
    container_name   = "kgh-web"
    container_port   = 80
  }
  
  tags = {
    Name = format("%s-web-service", var.tags.value)
    key                 = var.tags.key
    value               = var.tags.value
  }
}

# app service
resource "aws_ecs_service" "app_service" {
  iam_role        = aws_iam_role.ecs_service_role.name
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.app_task_def.arn
  launch_type     = "EC2"
  desired_count   = 3
  
 
  network_configuration {
    security_groups  = [aws_security_group.ecs_node_sg.id]
    subnets          = var.app_subnet_ids[*]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = var.tg_app
    container_name   = "kgh-app"
    container_port   = 8080
  }
  
  tags = {
    Name = format("%s-app-service", var.tags.value)
    key                 = var.tags.key
    value               = var.tags.value
  }
}