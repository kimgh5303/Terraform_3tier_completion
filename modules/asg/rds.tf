# RDS 데이터 소스 정의
data "aws_db_instance" "my_rds" {
  db_instance_identifier = aws_db_instance.rds_db.identifier
}

resource "aws_db_instance" "rds_db" {
  allocated_storage      = var.rds_db.allocated_storage
  db_name                = var.rds_db.db_name
  engine                 = var.rds_db.engine
  engine_version         = var.rds_db.engine_version
  instance_class         = var.rds_db.instance_class
  username               = var.db_user.db_username
  password               = var.db_user.db_password
  parameter_group_name   = var.rds_db.parameter_group_name
  multi_az               = var.rds_db.multi_az
  db_subnet_group_name   = var.db_subnet_grp
  vpc_security_group_ids = [var.db_sg]
  skip_final_snapshot    = var.rds_db.skip_final_snapshot
  identifier             = var.rds_db.identifier
  
  tags = {
    key                 = var.tags.key
    value               = var.tags.value
  }
}