data "template_file" "service" {
  template = file(var.tpl_path)
  vars = {
    region             = var.region
    aws_ecr_repository = aws_ecr_repository.repo.repository_url
    tag                = "latest"
    container_port     = var.container_port
    host_port          = var.host_port
    app_name           = var.app_name
  }
}

resource "aws_ecs_task_definition" "ecs_task_def" {
  family                   = "service-staging"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  cpu                      = 256
  memory                   = 512
  requires_compatibilities = ["EC2"]
  container_definitions    = data.template_file.service.rendered
  tags = {
    Environment = "staging"
    Application = var.app_name
  }
}

resource "aws_ecs_cluster" "ecs_cluster" {
  tags = {
    Name = format("%s-ecs-cluster", var.tags.value)
    key                 = var.tags.key
    value               = var.tags.value
  }
}

resource "aws_ecs_service" "ecs_service" {
  name            = "worker"
  cluster         = aws_ecs_cluster.ecs_cluster.id
  task_definition = aws_ecs_task_definition.ecs_task_def.arn
  launch_type     = "EC2"
  desired_count   = 3
  
 
  network_configuration {
    security_groups  = [aws_security_group.ecs_node_sg.id]
    subnets          = aws_subnet.cluster[*].id
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.staging.arn
    container_name   = var.app_name
    container_port   = var.container_port
  }

  # 종속성 문제로 인해 ECS와 관련한 서비스들을 먼저 나열
  depends_on = [aws_lb_listener.listener_rule_http_web, aws_iam_role_policy_attachment.ecs_task_execution_role]

  tags = {
    Environment = "staging"
    Application = var.app_name
  }
}