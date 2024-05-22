resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "kgh-ecs-task-execution-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"  # ECS 서비스에 대한 Principal
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}

resource "aws_iam_role_policy_attachment" "ecs_service_role_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceRole"
}

# ECS task IAM 정책 연결 
resource "aws_iam_policy_attachment" "ecs_policy_attachment" {
  name       = "ECSPolicyAttachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  depends_on = [aws_iam_role.ecs_task_execution_role]
}

# EC2 -> ECS 접근 역할 설정(시작 템플릿) # EC2 것
resource "aws_iam_role" "ecs_instance_role" {
  name               = "kgh-ecs-instance-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Effect    = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action    = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}

resource "aws_iam_policy_attachment" "ecs_instance_role_attachment" {
  name       = "ecsInstanceRoleAttachment"
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
  roles      = [aws_iam_role.ecs_task_execution_role.name]
  depends_on = [aws_iam_role.ecs_task_execution_role]
}

resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "kgh-ecs-instance-role"
  role = aws_iam_role.ecs_task_execution_role.id
}