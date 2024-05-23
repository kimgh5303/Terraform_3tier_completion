/*

## Define Target Tracking on ECS Cluster Task level # TASK 설정임!!! task(container) 수
resource "aws_appautoscaling_target" "ecs-target-web" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster-web.name}/${aws_ecs_service.web-ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}


## Policy for cpu tracking
resource "aws_appautoscaling_policy" "ecs_cpu_policy-web" {
  name               = "CPU-Target-Tracking-Scailing-web"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-target-web.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-target-web.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-target-web.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

## Policy for memory tracking
resource "aws_appautoscaling_policy" "ecs_memory_policy-web" {
  name               = "Memory-Target-Tracking-Scailing-web"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs-target-web.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs-target-web.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs-target-web.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}


## Define Target Tracking on ECS Cluster Task level
resource "aws_appautoscaling_target" "ecs_target-app" {
  max_capacity       = 3
  min_capacity       = 1
  resource_id        = "service/${aws_ecs_cluster.ecs-cluster-app.name}/${aws_ecs_service.app-ecs-service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

## Policy for cpu tracking
resource "aws_appautoscaling_policy" "ecs_cpu_policy-app" {
  name               = "CPU-Target-Tracking-Scailing-web"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target-app.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target-app.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target-app.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
  }
}

## Policy for memory tracking
resource "aws_appautoscaling_policy" "ecs_memory_policy-app" {
  name               = "Memory-Target-Tracking-Scailing-web"
  policy_type        = "TargetTrackingScaling"
  resource_id        = aws_appautoscaling_target.ecs_target-app.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs_target-app.scalable_dimension
  service_namespace  = aws_appautoscaling_target.ecs_target-app.service_namespace

  target_tracking_scaling_policy_configuration {
    target_value = 60

    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageMemoryUtilization"
    }
  }
}

*/