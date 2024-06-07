# ECS 태스크 정의 리소스
resource "aws_ecs_task_definition" "web-ecs-service" {
  family = "${var.web-prefix}-${var.ecs-family-name}"             # 태스크 정의의 고유 식별자
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn   # ECS 태스크 실행에 필요한 권한을 제공
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn        # ECS 태스크 내에서 실행되는 애플리케이션의 권한을 제공
  
  requires_compatibilities = ["EC2"]                              # 태스크 실행 환경을 EC2로 설정

  # 운영 체제 및 CPU 아키텍처 설정
  runtime_platform {
   operating_system_family = "LINUX"                              # 리눅스 기반 시스템 사용
   cpu_architecture        = "X86_64"                             # x86_64 아키텍처 사용
  }

  # 컨테이너 정의
  container_definitions = jsonencode([
    {
      name      = "web-nginx-container"
      image     = "381492154999.dkr.ecr.ap-northeast-2.amazonaws.com/frontend:latest"  # 사용할 도커 이미지
      cpu       = 10                    # 할당된 CPU 단위
      memory    = 256                   # 할당된 메모리(MB)
      essential = true                  # 이 컨테이너가 필수적인지 여부
      portMappings = [                  # 포트 매핑 설정
        {
          containerPort = 80
          hostPort      = 0             # 동적 호스트 포트 매핑
          protocol      = "tcp"         # TCP 프로토콜 사용
        }
      ],
      "essential": true,

      # 환경 변수 설정
      environment = [
        {
          name = "ALB"
          value = "${aws_lb.alb-app.dns_name}"  # ALB의 DNS 이름을 환경 변수로 전달
        }
      ],

      # 로깅 설정
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          awslogs-create-group  = "true",
          awslogs-group        = aws_cloudwatch_log_group.log_group-web.name,           # 로그 그룹
          awslogs-region       = var.region-name,                                       # 로그 저장 리전
          awslogs-stream-prefix = var.web-prefix                                        # 로그 스트림 접두어
        }
      }
    }
  ])

  # 볼륨 설정
  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  # 배치 제약 조건
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.az-1}, ${var.az-2}]"        # 특정 가용 영역에 배치
  }

  tags = {
    Name = "${var.web-prefix}-${var.ecs-task-definition}"
    Owner = var.owner-tag
  }
}

# ECS 태스크 정의 리소스
resource "aws_ecs_task_definition" "app-ecs-service" {
  family = "${var.app-prefix}-${var.ecs-family-name}"             # 태스크 정의의 고유 식별자
  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn   # ECS 태스크 실행에 필요한 권한을 제공
  task_role_arn = aws_iam_role.ecs_task_execution_role.arn        # ECS 태스크 내에서 실행되는 애플리케이션의 권한을 제공

  requires_compatibilities = ["EC2"]                              # 태스크 실행 환경을 EC2로 설정

  # 운영 체제 및 CPU 아키텍처 설정
  runtime_platform {
   operating_system_family = "LINUX"                              # 리눅스 기반 시스템 사용
   cpu_architecture        = "X86_64"                             # x86_64 아키텍처 사용
  }

  # 컨테이너 정의
  container_definitions = jsonencode([
    {
      name      = "app-nginx-container"
      image     = "381492154999.dkr.ecr.ap-northeast-2.amazonaws.com/backend:latest"  # 사용할 도커 이미지
      cpu       = 10                    # 할당된 CPU 단위
      memory    = 256                   # 할당된 메모리(MB)
      essential = true                  # 이 컨테이너가 필수적인지 여부
      portMappings = [                  # 포트 매핑 설정
        {
          containerPort = 80
          hostPort      = 0
        }
      ],
      "essential": true,

      # 환경 변수 설정
      # 컨테이너가 실행될 때 필요한 모든 데이터베이스 연결 정보를 제공
      environment = [
        {name = "rds_endpoint", value = "${data.aws_db_instance.my_rds.endpoint}"},
        {name = "HOST", value = "${local.host}"},
        {name = "USERNAME", value = "${var.db-username}"},
        {name = "PASSWORD", value = "${var.db-password}"},
        {name = "DB", value = "${var.db-name}"},
      ],
      
      # 로깅 설정
      logConfiguration = {
        logDriver = "awslogs",
        options   = {
          awslogs-create-group  = "true",
          awslogs-group        = aws_cloudwatch_log_group.log_group-app.name,           # 로그 그룹
          awslogs-region       = var.region-name,                                       # 로그 저장 리전
          awslogs-stream-prefix = var.app-prefix                                        # 로그 스트림 접두어
        }
      }
    }
  ])

  # 볼륨 설정
  volume {
    name      = "service-storage"
    host_path = "/ecs/service-storage"
  }

  # 배치 제약 조건
  placement_constraints {
    type       = "memberOf"
    expression = "attribute:ecs.availability-zone in [${var.az-1}, ${var.az-2}]"        # 특정 가용 영역에 배치
  }

  tags = {
    Name = "${var.app-prefix}-${var.ecs-task-definition}"
    Owner = var.owner-tag
  }
}