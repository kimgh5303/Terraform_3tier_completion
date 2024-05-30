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
  db_subnet_group_name   = aws_db_subnet_group.subnet-grp.name
  vpc_security_group_ids = [aws_security_group.db-sg.id]
  skip_final_snapshot    = true
  identifier = "my-rds-instance" // RDS 인스턴스의 이름 지정

  multi_az               = true                    # multi-az
  backup_retention_period = 7                      # 자동 백업을 유지하는 기간
  backup_window = "07:00-09:00"          # 자동 백업이 수행될 하루 중 시간을 지정

  tags = {
    Name = "my-rds-instance"
    Owner = var.owner-tag
  }
}

# DB 스키마 설정-----------------------------------------------------------
resource "null_resource" "db_schema_setup" {
  depends_on = [aws_db_instance.rds-db]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.bastion.public_ip
      private_key = file(local_file.private_key_pem.filename)
    }

    inline = [
      # MySQL Community Repository 추가
      "sudo yum install -y https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm",
      "sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023",

      # MySQL 클라이언트 설치
      "sudo yum install -y mysql-community-client"
    ]
  }
}



