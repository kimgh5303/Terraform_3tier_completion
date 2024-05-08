# root module에서 정의한 변수를 받아옴
# 공통 태그 이니셜 -> kgh
variable "tags" {}

# vpc 모듈의 vpc id를 받아옴
variable "vpc_id" {}

variable "alb_web_sg" {}
variable "alb_app_sg" {}

variable "public_subnet_ids" {}
variable "app_subnet_ids" {}

variable "alb_web_name" {}
variable "alb_app_name" {}
variable "tg_web_name" {}
variable "tg_app_name" {}

variable "health_checks" {}