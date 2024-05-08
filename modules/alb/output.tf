# 모듈간의 데이터 공유를 위해 사용
# web alb의 dns name
output "alb_web_dns" {
  value = aws_lb.alb_web.dns_name
}

output "alb_web" {
  value = aws_lb.alb_web
}

output "tg_web" {
  value = aws_lb_target_group.tg_web.arn
}

output "tg_app" {
  value = aws_lb_target_group.tg_app.arn
}