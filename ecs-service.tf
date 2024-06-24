# Web ECS 서비스 정의
resource "aws_ecs_service" "web-ecs-service" {
  name            = "${var.web-prefix}-${var.ecs-service-name}"
  cluster         = aws_ecs_cluster.ecs-cluster-web.id            # 사용할 ECS 클러스터의 ID
  task_definition = aws_ecs_task_definition.web-ecs-service.arn   # 사용할 태스크 정의의 ARN
  desired_count   = 4                                             # 태스크의 수

  # 의존성 설정
  depends_on = [aws_ecs_task_definition.web-ecs-service,aws_ecs_cluster.ecs-cluster-web]

  # 배치 전략 : spread 전략 - 지정된 가용 영역에 따라 태스크를 고르게 분산
  # 태스크가 여러 가용 영역에 걸쳐 배치되도록, 단일 지점 장애를 방지
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"                     # 가용 영역을 기준으로 분산
  }

  # 배치 전략 : binpack 전략 - 주어진 메모리를 기준으로 클러스터의 리소스 사용을 최적화
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"                                              # 메모리 기준으로 리소스를 최적화하여 배치
  }

  # 로드 밸런서 설정: 서비스에 연결된 타겟 그룹과 컨테이너 정보
  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-web.arn
    container_name   = "web-nginx-container"                      # 타겟 그룹과 연결된 컨테이너 이름
    container_port   = 80                                         # 컨테이너가 수신하는 포트
  }

  # 태스크 배치 제약 조건: 태스크가 특정 가용 영역에서만 실행되도록 설정
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone == ${var.az-1} || attribute:ecs.availability-zone == ${var.az-2}"
  }

  tags = {
    Name = "${var.web-prefix}-${var.ecs-service-name}"
    Owner = var.owner-tag
  }
}

# App ECS 서비스 정의
resource "aws_ecs_service" "app-ecs-service" {
  name            = "${var.app-prefix}-${var.ecs-service-name}"
  cluster         = aws_ecs_cluster.ecs-cluster-app.id            # 사용할 ECS 클러스터의 ID
  task_definition = aws_ecs_task_definition.app-ecs-service.arn   # 사용할 태스크 정의의 ARN
  desired_count   = 4                                             # 태스크의 수
  
  # 의존성 설정
  depends_on = [aws_ecs_task_definition.app-ecs-service,aws_ecs_cluster.ecs-cluster-app]

  # 배치 전략 : spread 전략 - 지정된 가용 영역에 따라 태스크를 고르게 분산
  # 태스크가 여러 가용 영역에 걸쳐 배치되도록, 단일 지점 장애를 방지
  ordered_placement_strategy {
    type  = "spread"
    field = "attribute:ecs.availability-zone"
  }

  # 배치 전략 : binpack 전략 - 주어진 메모리를 기준으로 클러스터의 리소스 사용을 최적화
  ordered_placement_strategy {
    type  = "binpack"
    field = "memory"
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.target-group-app.arn
    container_name   = "app-nginx-container"                      # 타겟 그룹과 연결된 컨테이너 이름
    container_port   = 80                                         # 컨테이너가 수신하는 포트
  }

  # 태스크 배치 제약 조건: 태스크가 특정 가용 영역에서만 실행되도록 설정
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone == ${var.az-1} || attribute:ecs.availability-zone == ${var.az-2}"
  }

  tags = {
    Name = "${var.app-prefix}-${var.ecs-service-name}"
    Owner = var.owner-tag
  }
}