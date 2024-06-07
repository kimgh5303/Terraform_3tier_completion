resource "aws_db_subnet_group" "subnet-grp" {
  name       = var.db-subnet-grp-name
  subnet_ids = [aws_subnet.db-subnet1.id,aws_subnet.db-subnet2.id]
  # 서브넷 그룹에 포함될 DB 서브넷의 ID 목록을 지정
  # Multi-AZ 데이터베이스 배치를 위함

  tags = {
    Name = var.db-subnet-grp-name
    Owner = var.owner-tag
  }
}
