resource "aws_launch_template" "template-app" {
  name          = var.launch-template-app-name
  image_id      = var.image-id                                        # 사용할 AMI ID
  instance_type = var.instance-type                                   # EC2 인스턴스 타입
  
  # IAM 인스턴스 프로필 설정 : ECS 인스턴스에 할당
  iam_instance_profile {
    arn = aws_iam_instance_profile.ecs_instance_profile.arn           # ECS 인스턴스 프로필의 ARN
  }

  # 모니터링 활성화 설정: EC2 인스턴스에 대한 상세 모니터링
  monitoring {
    enabled = true                                                    # EC2 인스턴스에 대한 상세 모니터링 활성화
  }

  lifecycle {
    create_before_destroy = true                                      # 새 리소스를 생성하기 전에 기존 리소스를 제거
  }

  # 네트워크 인터페이스 설정
  network_interfaces {
    device_index    = 0                                               # 인터페이스의 인덱스
    security_groups = [aws_security_group.asg-security-group-app.id]  # 사용할 보안 그룹
  }

  # 인스턴스 메타데이터 옵션
  metadata_options {
    http_endpoint               = "enabled"                           # 인스턴스 메타데이터 엔드포인트 활성화
    http_tokens                 = "required"                          # 메타데이터 요청에 필요한 토큰 사용
    http_put_response_hop_limit = 1                                   # 메타데이터 요청의 홉 제한
    instance_metadata_tags      = "enabled"                           # 인스턴스 메타데이터 태깅 활성화
  }

  # 사용자 데이터 설정 : 인스턴스 시작 시 실행할 스크립트
  user_data = base64encode(templatefile("app-user-data.sh",{
    ecs-cluster-name = "${var.app-prefix}-${var.ecs-cluster-name}"    # ECS 클러스터 이름 전달
  }))

  # RDS 데이터베이스 인스턴스 생성 후 Launch Template 생성되도록 의존성 설정
  # 데이터베이스 연결 설정을 완료해야 할 경우를 위함
  depends_on = [
    aws_db_instance.rds-db
  ]

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = var.app-instance-name
      Owner = var.owner-tag
    }
  }
}

# 로컬 변수: RDS 데이터베이스 연결 정보 관리
locals {
  rds_endpoint = "${data.aws_db_instance.my_rds.endpoint}"            # RDS 엔드포인트
  host = replace(local.rds_endpoint, ":3306", "")                     # RDS 호스트 주소 추출
}