# ECS 용량 제공자 정의
resource "aws_ecs_capacity_provider" "web_ecs_capacity_provider" {
  name = "web-ecs-capacity-provider"

  # Auto Scaling Group (ASG) 제공자 설정
  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.asg_web_arn
    managed_termination_protection = "DISABLED"       # 관리되는 종료 보호 비활성화

    # ASG에 대한 관리형 스케일링 설정
    managed_scaling {
      maximum_scaling_step_size = 2           # 한 번에 확장할 최대 인스턴스 수
      minimum_scaling_step_size = 1           # 한 번에 축소할 최소 인스턴스 수
      status                    = "ENABLED"   # 관리형 스케일링 활성화
      target_capacity           = 100         # 목표 용량 백분율
    }
  }
  depends_on = [var.asg_web_arn]

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}

resource "aws_ecs_capacity_provider" "app_ecs_capacity_provider" {
  name = "app-ecs-capacity-provider"

  # Auto Scaling Group (ASG) 제공자 설정
  auto_scaling_group_provider {
    auto_scaling_group_arn         = var.asg_app_arn
    managed_termination_protection = "DISABLED"       # 관리되는 종료 보호 비활성화

    # ASG에 대한 관리형 스케일링 설정
    managed_scaling {
      maximum_scaling_step_size = 2           # 한 번에 확장할 최대 인스턴스 수
      minimum_scaling_step_size = 1           # 한 번에 축소할 최소 인스턴스 수
      status                    = "ENABLED"   # 관리형 스케일링 활성화
      target_capacity           = 100         # 목표 용량 백분율
    }
  }
  depends_on = [var.asg_web_arn]

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}

# ECS 클러스터 용량 제공자 설정
resource "aws_ecs_cluster_capacity_providers" "web_ecs_cluster_capacity_provider" {
  cluster_name       = aws_ecs_cluster.ecs_cluster_web.name
  capacity_providers = [aws_ecs_capacity_provider.web_ecs_capacity_provider.name]     # 사용될 용량 제공자 목록

  # 기본 용량 제공자 전략 설정
  default_capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.web_ecs_capacity_provider.name
    base              = 1           # 기본 인스턴스 수
    weight            = 100         # 가중치
  }
}