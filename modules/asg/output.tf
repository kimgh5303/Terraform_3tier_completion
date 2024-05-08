output "rds-endpoint" {
  value = data.aws_db_instance.my_rds.endpoint
}