# Web ECS 클러스터 생성
resource "aws_ecs_cluster" "ecs-cluster-web" {
  name = "${var.web-prefix}-${var.ecs-cluster-name}"

  # 컨테이너 인사이트 설정: 성능 모니터링 및 관리 기능 활성화
  setting {
    name  = "containerInsights"                       # 설정 항목 이름
    value = "enabled"                                 # 컨테이너 인사이트 활성화
  }

  # 클러스터 삭제 전 새 리소스 생성을 보장하는 라이프사이클 정책
  lifecycle {
    create_before_destroy = true                      # 새 리소스 생성 후 기존 리소스 제거
  }

  tags = {
    Name = "${var.web-prefix}-${var.ecs-cluster-name}"
    Owner = var.owner-tag
  }
}

# App ECS 클러스터 생성
resource "aws_ecs_cluster" "ecs-cluster-app" {
  name = "${var.app-prefix}-${var.ecs-cluster-name}"

  setting {
    name  = "containerInsights"                       # 설정 항목 이름
    value = "enabled"                                 # 컨테이너 인사이트 활성화
  }

  # 클러스터 삭제 전 새 리소스 생성을 보장하는 라이프사이클 정책
  lifecycle {
    create_before_destroy = true                      # 새 리소스 생성 후 기존 리소스 제거
  }

  tags = {
    Name = "${var.app-prefix}-${var.ecs-cluster-name}"
    Owner = var.owner-tag
  }
}
