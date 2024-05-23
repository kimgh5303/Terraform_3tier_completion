output "region" {
  value = data.aws_region.current
}

output "web-alb-dns" {
  value = aws_lb.alb-web.dns_name
}

output "web-app-dns" {
  value = aws_lb.alb-app.dns_name
}

output "rds-endpoint" {
  value = data.aws_db_instance.my_rds.endpoint
}
