# 모듈간의 데이터 공유를 위해 사용
output "alb_web_sg" { 
  value = aws_security_group.alb_web_sg.id
}

output "alb_app_sg" { 
  value = aws_security_group.alb_app_sg.id
}

output "db_sg" { 
  value = aws_security_group.db_sg.id
}