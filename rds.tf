# RDS 데이터 소스 정의
data "aws_db_instance" "my_rds" {
  db_instance_identifier = aws_db_instance.rds-db.identifier
}

resource "aws_db_instance" "rds-db" {
  allocated_storage      = 10
  db_name                = var.db-name
  engine                 = "mysql"
  engine_version         = "8.0"
  storage_type           = "gp2"
  instance_class         = var.instance-class
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
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


locals {
  db_endpoint = split(":", aws_db_instance.rds-db.endpoint)[0]
}

# DB 스키마 설정-----------------------------------------------------------
resource "null_resource" "db_schema_setup" {
  depends_on = [aws_db_instance.rds-db]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.bastion.public_ip
      private_key = file(local_file.private_key_pem.filename)
    }

    source      = "./init.sql"
    destination = "/home/ec2-user/init.sql"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.bastion.public_ip
      private_key = file(local_file.private_key_pem.filename)
    }

    inline = [
      # MySQL Community Repository 추가
      "sudo yum install -y https://dev.mysql.com/get/mysql80-community-release-el7-3.noarch.rpm",
      "sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2022",

      # MySQL 클라이언트 설치
      "sudo yum install -y mysql-community-client",

      # SSH 터널링 및 스키마 적용
      "mysql -h ${local.db_endpoint} -P 3306 -u ${var.db_username} -p${var.db_password} < /home/ec2-user/init.sql"
    ]
  }
}

