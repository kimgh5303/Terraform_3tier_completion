# root module에서 정의한 변수를 받아옴
# 공통 태그 이니셜 -> kgh
variable "region" {}
variable "tags" {}

variable "tg_web" {}

variable "asg_web_arn" {}

variable "web_subnet_ids" {}
variable "app_subnet_ids" {}