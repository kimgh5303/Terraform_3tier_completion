/*
output "rds-endpoint" {
  value = data.aws_db_instance.my_rds.endpoint
}
*/

output "asg_web_arn" { 
  value = aws_autoscaling_group.asg_web.arn
} 