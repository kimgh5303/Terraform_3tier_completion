# 모듈간의 데이터 공유를 위해 사용
output "vpc_id" { 
  value = aws_vpc.vpc.id
} 

output "public_subnet_ids" {
  value = {for k, subnet in aws_subnet.public_subnets : k => subnet.id}
}

output "web_subnet_ids" {
  value = {for k, subnet in aws_subnet.web_subnets : k => subnet.id}
}

output "app_subnet_ids" {
  value = {for k, subnet in aws_subnet.app_subnets : k => subnet.id}
}

output "db_subnet_grp" {
  value = aws_db_subnet_group.db_subnet_grp.name
}