# root module에서 정의한 변수를 받아옴
# 공통 태그 이니셜 -> kgh
variable "tags" {}
variable "az_1" {}
variable "az_2" {}

variable "alb_app_dns" {}

variable "rds_endpoint" {}
variable "db_user" {}
variable "rds_db" {}

variable "tg_web" {}
variable "tg_app" {}

variable "asg_web_arn" {}
variable "asg_app_arn" {}

variable "web_subnet_ids" {}
variable "app_subnet_ids" {}
