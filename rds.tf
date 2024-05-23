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

# DB 스키마 설정-----------------------------------------------------------
resource "null_resource" "db_schema_setup" {
  depends_on = [aws_db_instance.my_rds]

  provisioner "file" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.bastion.public_ip
      private_key = file("~/.ssh/ec2_cert.pem")
    }

    source      = "./init.sql"
    destination = "/home/ec2-user/init.sql"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.bastion.public_ip
      private_key = tls_private_key.private_key.private_key_pem
    }

    inline = [
      # SSH 터널링 설정 및 스키마 적용
      "ssh -o StrictHostKeyChecking=no -f -N -L 3306:${aws_db_instance.my_rds.address}:3306 ec2-user@${aws_instance.bastion.public_ip}",
      "mysql --host=127.0.0.1 --port=3306 --user=${aws_db_instance.my_rds.username} --password=${aws_db_instance.my_rds.password} < /home/ec2-user/schema.sql"
    ]
  }
}

