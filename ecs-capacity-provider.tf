resource "aws_ecs_capacity_provider" "web-ecs-capacity-provider" {
  name = "${var.web-prefix}-${var.ecs-capacity-provider}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg-web.arn
    managed_termination_protection = "DISABLED"

    # 자동 확장 관리 설정 - 태스크 수에 반응
    managed_scaling {
      maximum_scaling_step_size = 2                     # 한 번의 스케일링 작업으로 추가할 수 있는 최대 인스턴스 수
      minimum_scaling_step_size = 1                     # 한 번의 스케일링 작업으로 제거할 수 있는 최대 인스턴스 수
      status                    = "ENABLED"             # 스케일링 활성화
      ## Capacity Provider가 유지하려는 대상 용량
      target_capacity           = 100
    }
  }
  depends_on = [aws_autoscaling_group.asg-web]

  tags = {
    Name = "${var.web-prefix}-${var.ecs-capacity-provider}"
    Owner = var.owner-tag
  } 
}

resource "aws_ecs_capacity_provider" "app-ecs-capacity-provider" {
  name = "${var.app-prefix}-${var.ecs-capacity-provider}"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.asg-app.arn
    managed_termination_protection = "DISABLED"

    # 자동 확장 관리 설정
    managed_scaling {

      ## 한 번에 조정할 수 있는 인스턴스 지정
      maximum_scaling_step_size = 2
      minimum_scaling_step_size = 1 
      status                    = "ENABLED"
      ## Capacity Provider가 유지하려는 대상 용량
      target_capacity           = 100
    }
  }

  depends_on = [aws_autoscaling_group.asg-app]

  tags = {
    Name = "${var.app-prefix}-${var.ecs-capacity-provider}"
    Owner = var.owner-tag
  }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers-web" {
 cluster_name = aws_ecs_cluster.ecs-cluster-web.name

 capacity_providers = [aws_ecs_capacity_provider.web-ecs-capacity-provider.name]

 default_capacity_provider_strategy {
   base              = 1
   weight            = 100
   capacity_provider = aws_ecs_capacity_provider.web-ecs-capacity-provider.name
 }
}

resource "aws_ecs_cluster_capacity_providers" "ecs_cluster_capacity_providers-app" {
 cluster_name = aws_ecs_cluster.ecs-cluster-app.name

 capacity_providers = [aws_ecs_capacity_provider.app-ecs-capacity-provider.name]
  
 default_capacity_provider_strategy {
   base              = 1
   weight            = 100
   capacity_provider = aws_ecs_capacity_provider.app-ecs-capacity-provider.name
 }
}


