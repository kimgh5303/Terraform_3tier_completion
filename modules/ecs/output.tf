# 모듈간의 데이터 공유를 위해 사용
output "ecs_cluster" { 
  value = aws_ecs_cluster.ecs_cluster.name
} 