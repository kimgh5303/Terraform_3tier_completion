# Web ECS Capacity Provider 생성
resource "aws_ecs_capacity_provider" "web-ecs-capacity-provider" {
  name = "${var.web-prefix}-${var.ecs-capacity-provider}"

  # Auto Scaling Group 정보 및 관리 설정
  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg-web.arn      # 연결된 ASG의 ARN
    managed_termination_protection = "DISABLED"                             # 관리된 종료 보호 비활성화

    # 자동 확장 관리 설정 - 태스크 수에 반응
    managed_scaling {
      maximum_scaling_step_size = 2                     # 스케일 아웃 최대 인스턴스 수
      minimum_scaling_step_size = 1                     # 스케일 인 최소 인스턴스 수
      status                    = "ENABLED"             # 스케일링 활성화
      # Capacity Provider가 유지하려는 대상 용량
      target_capacity           = 100
    }
  }
  depends_on = [aws_autoscaling_group.asg-web]          # ASG가 있어야 함

  tags = {
    Name = "${var.web-prefix}-${var.ecs-capacity-provider}"
    Owner = var.owner-tag
  } 
}

# App ECS Capacity Provider 생성
resource "aws_ecs_capacity_provider" "app-ecs-capacity-provider" {
  name = "${var.app-prefix}-${var.ecs-capacity-provider}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg-app.arn      # 연결된 ASG의 ARN
    managed_termination_protection = "DISABLED"                             # 관리된 종료 보호 비활성화

    # 자동 확장 관리 설정
    managed_scaling {

      ## 한 번에 조정할 수 있는 인스턴스 지정
      maximum_scaling_step_size = 2                     # 스케일 아웃 최대 인스턴스 수
      minimum_scaling_step_size = 1                     # 스케일 인 최소 인스턴스 수
      status                    = "ENABLED"             # 스케일링 활성화
      ## Capacity Provider가 유지하려는 대상 용량
      target_capacity           = 100
    }
  }

  depends_on = [aws_autoscaling_group.asg-app]          # ASG가 있어야 함

  tags = {
    Name = "${var.app-prefix}-${var.ecs-capacity-provider}"
    Owner = var.owner-tag
  }
}

# Web ECS Capacity Provider 연결
resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers-web" {
  cluster_name = aws_ecs_cluster.ecs-cluster-web.name

  capacity_providers = [aws_ecs_capacity_provider.web-ecs-capacity-provider.name]  # 사용할 Capacity Provider

  # 기본 Capacity Provider 전략
  default_capacity_provider_strategy {
    base              = 1                     # base 값 설정. 최소 인스턴스 수를 의미
    weight            = 100                   # 태스크 배포 시 Capacity Provider의 상대적 우선순위를 결정
    capacity_provider = aws_ecs_capacity_provider.web-ecs-capacity-provider.name   # 전략에 사용될 Capacity Provider의 이름
  }
}

# App ECS Capacity Provider 연결
resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers-app" {
  cluster_name = aws_ecs_cluster.ecs-cluster-app.name

  capacity_providers = [aws_ecs_capacity_provider.app-ecs-capacity-provider.name]
    
  default_capacity_provider_strategy {
    base              = 1                     # base 값 설정. 최소 인스턴스 수를 의미
    weight            = 100                   # 태스크 배포 시 Capacity Provider의 상대적 우선순위를 결정
    capacity_provider = aws_ecs_capacity_provider.app-ecs-capacity-provider.name   # 전략에 사용될 Capacity Provider의 이름
  }
}


