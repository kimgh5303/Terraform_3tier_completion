# root module에서 정의한 변수를 받아옴
# 공통 태그 이니셜 -> kgh
variable "tags" {}

# sg 모듈의 id
variable "alb_web_sg" {}
variable "alb_app_sg" {}
# alb 모듈
variable "alb_web_dns" {}
variable "alb_web" {}
variable "tg_web" {}
variable "tg_app" {}
variable "web_subnet_ids" {}
variable "app_subnet_ids" {}

variable "template_web_name" {}
variable "template_app_name" {}
variable "ami_id" {}
variable "instance_type" {}
variable "metadata_options" {}
variable "asg_web_name" {}
variable "asg_app_name" {}

variable "db_subnet_grp" {}
variable "db_sg" {}
variable "rds_db" {}
variable "db_user" {}
