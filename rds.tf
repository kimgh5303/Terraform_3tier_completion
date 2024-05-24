resource "aws_db_parameter_group" "mysql8-parameter-group" {
  name        = "mysql8-parameter-group"
  family      = "mysql8.0" // MySQL 8.0 엔진을 사용하는 경우
  description = "Parameter group for MySQL 8.0"
  
  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }
  
  parameter {
    name  = "collation_server"
    value = "utf8mb4_unicode_ci"
  }
  
  // 필요한 다른 매개 변수를 여기에 추가할 수 있습니다.
}
# RDS 데이터 소스 정의
data "aws_db_instance" "my_rds" {
  db_instance_identifier = aws_db_instance.rds-db.identifier
}

resource "aws_db_instance" "rds-db" {
  allocated_storage      = 10
  db_name                = var.db-name
  engine                 = "mysql"
  engine_version         = "8.0"
  storage_type         = "gp2"
  
  instance_class         = var.instance-class
  username               = var.db-username
  password               = var.db-password
  parameter_group_name   = aws_db_parameter_group.mysql8-parameter-group.name
  multi_az               = false   # multi-az 추후 활성화 할 것
  db_subnet_group_name   = aws_db_subnet_group.subnet-grp.name
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  skip_final_snapshot    = true
  identifier = "my-rds-instance" // RDS 인스턴스의 이름 지정


  tags = {
    Name = "my-rds-instance"
    Owner = var.owner-tag
  }
}




