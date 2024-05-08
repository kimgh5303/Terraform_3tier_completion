# root module에서 정의한 변수를 받아옴
# 공통 태그 이니셜 -> kgh
variable "tags" {}

# vpc 모듈의 vpc id를 받아옴
variable "vpc_id" {}

variable "ingress_rule" {}
variable "egress_rule" {}