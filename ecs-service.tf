## web
resource "aws_ecs_service" "web-ecs-service" {
  name            = "${var.web-prefix}-${var.ecs-service-name}"
  cluster         = aws_ecs_cluster.ecs-cluster-web.id
  task_definition = aws_ecs_task_definition.web-ecs-service.arn
  desired_count   = 4

  depends_on = [aws_ecs_task_definition.web-ecs-service,aws_ecs_cluster.ecs-cluster-web]

  # spread 전략 - 지정된 가용 영역에 따라 태스크를 고르게 분산
  # 태스크가 여러 가용 영역에 걸쳐 배치되도록, 단일 지점 장애를 방지
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }
  # binpack 전략 - 주어진 메모리를 기준으로 클러스터의 리소스 사용을 최적화
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-web.arn
    container_name   = "web-nginx-container"
    container_port   = 80
  }

  # 태스크가 특정 조건을 만족하는 노드에만 배치되도록 제약 조건 설정
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone == ${var.az-1} || attribute:ecs.availability-zone == ${var.az-2}"
  }

  tags = {
    Name = "${var.web-prefix}-${var.ecs-service-name}"
    Owner = var.owner-tag
  }
}

## app
resource "aws_ecs_service" "app-ecs-service" {
  name            = "${var.app-prefix}-${var.ecs-service-name}"
  cluster         = aws_ecs_cluster.ecs-cluster-app.id
  task_definition = aws_ecs_task_definition.app-ecs-service.arn
  desired_count   = 4
  depends_on = [aws_ecs_task_definition.app-ecs-service,aws_ecs_cluster.ecs-cluster-app]

  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-app.arn
    container_name   = "app-nginx-container"
    container_port   = 80
  }

  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone == ${var.az-1} || attribute:ecs.availability-zone == ${var.az-2}"
  }

  tags = {
    Name = "${var.app-prefix}-${var.ecs-service-name}"
    Owner = var.owner-tag
  }
}