# root module에서 정의한 변수를 받아옴
# 공통 태그 이니셜 -> kgh
variable "tags" {}

# vpc_cidr
variable "vpc_cidr" {}

# Public Subnet list
variable "public_subnets" {}

# Private Subnet list
variable "web_subnets" {}
variable "app_subnets" {}
variable "db_subnets" {}

# public route table cidr_block
variable "rt_cidr_blocks" {}