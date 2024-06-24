resource "aws_autoscaling_group" "asg-web" {
  name                = var.asg-web-name
  desired_capacity    = 2                         # 시작 인스턴스 수
  max_size            = 6                         # ASG가 관리할 수 있는 최대 인스턴스 수
  min_size            = 2                         # ASG가 관리할 수 있는 최소 인스턴스 수
  target_group_arns   = [aws_lb_target_group.target-group-web.arn]  # 연결된 타겟 그룹의 ARN

  # 인스턴스 Health Check 유형 설정
  health_check_type   = "EC2"                     # 인스턴스 상태를 Health Check 유형으로 사용

  # ASG에 포함될 서브넷 지정
  vpc_zone_identifier = [aws_subnet.web-subnet1.id, aws_subnet.web-subnet2.id]

  # 활성화할 CloudWatch 메트릭 설정
  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances"
  ]

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true                    # 인스턴스 생성 시 태그 자동 적용
  }

  launch_template {
    id      = aws_launch_template.template-web.id
    version = aws_launch_template.template-web.latest_version
  }

  # 인스턴스 새로고침 전략 설정
  # ASG 내의 모든 인스턴스를 자동으로 교체하여 최신 상태를 유지하고, 구성 변경이나 업데이트를 적용
  instance_refresh {
    strategy = "Rolling"                          # 롤링 업데이트 전략
    preferences {
      min_healthy_percentage = 50                 # 업데이트 중 Healthy 인스턴스 최소 비율 명시
    }
    triggers = ["tag"]
  }

  # 라이프사이클 정책 설정
  # 리소스의 생성 및 파괴 순서를 제어, 업데이트 중에 발생할 수 있는 충돌이나 중단을 방지
  lifecycle {
    create_before_destroy = true                  # 새 리소스 생성 후 기존 리소스 제거
    # 배포 중 서비스가 계속 운영될 수 있게 함
  }

  # 인스턴스 보호 설정(축소 scale-in)
  # 특정 인스턴스를 스케일-인으로부터 보호하여 중요 작업이 중단되지 않도록 할 수 있게 함
  protect_from_scale_in = false                   # 스케일 인 시 인스턴스 보호 비활성화 (Scale-in 보호)
}