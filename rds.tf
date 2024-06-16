resource "aws_db_parameter_group" "mysql8-parameter-group" {
  name        = "mysql8-parameter-group"                # 파라미터 그룹의 이름
  family      = "mysql8.0"                              # MySQL 8.0 엔진을 위한 파라미터 그룹
  description = "Parameter group for MySQL 8.0"
  
  # 문자 인코딩 설정
  parameter {
    name  = "character_set_server"                      # 서버의 기본 문자 인코딩 설정
    value = "utf8mb4"                                   # 4바이트 UTF-8 인코딩 사용
  }

  # 문자 정렬 순서 설정  
  parameter {
    name  = "collation_server"                          # 문자 정렬 순서(collation)
    value = "utf8mb4_unicode_ci"                        # 유니코드를 기반으로 한 문자 정렬 순서
  }
}

# RDS 데이터 소스 정의
data "aws_db_instance" "my_rds" {
  db_instance_identifier = aws_db_instance.rds-db.identifier  # RDS 인스턴스 식별자
}

resource "aws_db_instance" "rds-db" {
  allocated_storage      = 20                           # 할당된 스토리지 크기 (GB)
  db_name                = var.db-name
  engine                 = "mysql"                      # 데이터베이스 엔진
  engine_version         = "8.0"                        # MySQL 8.0 버전
  storage_type         = "gp2"                          # 일반 SSD 스토리지 사용
  
  instance_class         = var.instance-class           # 인스턴스 타입
  username               = var.db-username              # 데이터베이스 사용자 이름
  password               = var.db-password              # 데이터베이스 비밀번호
  parameter_group_name   = aws_db_parameter_group.mysql8-parameter-group.name   # 사용할 파라미터 그룹
  db_subnet_group_name   = aws_db_subnet_group.subnet-grp.name
  vpc_security_group_ids = [aws_security_group.db-sg.id]                        # DB 보안 그룹 ID
  skip_final_snapshot    = true                         # 인스턴스 삭제 시 최종 스냅샷을 생성하지 않음
  identifier = "my-rds-instance"                        # RDS 인스턴스의 고유 식별자

  multi_az               = true                         # 고가용성을 위해 Multi-AZ 배포 활성화

  tags = {
    Name = "my-rds-instance"
    Owner = var.owner-tag
  }
}

# DB bastion 설정-----------------------------------------------------------
resource "null_resource" "db_schema_setup" {
  # RDS 인스턴스가 준비된 후에 실행되도록 의존성 설정
  depends_on = [aws_db_instance.rds-db]

  # 원격 실행 프로비저너 사용
  provisioner "remote-exec" {
    # SSH 연결 구성
    connection {
      type        = "ssh"
      user        = "ec2-user"
      host        = aws_instance.bastion.public_ip      # Bastion 호스트의 공개 IP를 사용하여 연결
      private_key = file(local_file.private_key_pem.filename)   # SSH 연결을 위한 개인 키 파일
    }

    inline = [
      # MySQL Community Repository 추가
      "sudo yum install -y https://dev.mysql.com/get/mysql80-community-release-el9-1.noarch.rpm",
      # MySQL GPG 키를 시스템에 추가하여 패키지의 무결성 검증
      "sudo rpm --import https://repo.mysql.com/RPM-GPG-KEY-mysql-2023",

      # MySQL 클라이언트 설치 : RDS 인스턴스를 관리할 수 있도록 클라이언트 소프트웨어 설치
      "sudo yum install -y mysql-community-client"
    ]
  }
}
