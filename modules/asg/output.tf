output "rds_endpoint" {
  value = data.aws_db_instance.my_rds.endpoint
}

output "host" {
  value = local.host
}

output "asg_web_arn" { 
  value = aws_autoscaling_group.asg_web.arn
} 

output "asg_app_arn" { 
  value = aws_autoscaling_group.asg_app.arn
} 