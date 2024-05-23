/*
resource "aws_ecr_repository" "ecr" {
  name                 = var.ecs-ecr
  image_tag_mutability = "IMMUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Name = var.ecs-ecr
    Owner = var.owner-tag
  }

}
*/
/*
# Docker 이미지 빌드 및 ECR에 푸시
resource "null_resource" "build_and_push_image-web" {
  triggers = {
    # ECR 리포지터리가 생성될 때마다 실행
    ecr_repository_id = aws_ecr_repository.ecr.id
  }

  provisioner "local-exec" {
    command = <<EOF
      # Docker 이미지 빌드
      docker build -t frontend ./frontend
      
      # ECR 로그인
      $(aws ecr get-login --no-include-email --region ${var.region-name})
      
      # Docker 이미지를 ECR에 푸시
      docker tag frontend:latest ${aws_ecr_repository.ecr.repository_url}:latest
      docker push ${aws_ecr_repository.ecr.repository_url}:latest
    EOF
  }
}

# Docker 이미지 빌드 및 ECR에 푸시
resource "null_resource" "build_and_push_image-app" {
  triggers = {
    # ECR 리포지터리가 생성될 때마다 실행
    ecr_repository_id = aws_ecr_repository.ecr.id
  }

  provisioner "local-exec" {
    command = <<EOF
      # Docker 이미지 빌드
      docker build -t backend ./backend
      
      # ECR 로그인
      $(aws ecr get-login --no-include-email --region ${var.region-name})
      
      # Docker 이미지를 ECR에 푸시
      docker tag backend:latest ${aws_ecr_repository.ecr.repository_url}:latest
      docker push ${aws_ecr_repository.ecr.repository_url}:latest
    EOF
  }
}
*/