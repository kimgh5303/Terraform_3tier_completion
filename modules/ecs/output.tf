# 모듈간의 데이터 공유를 위해 사용
output "web_ecs_cluster" { 
  value = aws_ecs_cluster.web_ecs_cluster.name
}

output "app_ecs_cluster" { 
  value = aws_ecs_cluster.web_ecs_cluster.name
}