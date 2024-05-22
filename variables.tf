# 기본 환경 ----------------------------------------------
# Region
variable "region" {
  type    = string
}

# 공통 태그 이니셜
variable "tags" {
  description = "사용 구분자 태그"
  type = map(string)
}

variable "az_1" {
  type    = string
  description = "가용 영역1"
}

variable "az_2" {
  type    = string
  description = "가용 영역2"
}

# VPC----------------------------------------------------
# VPC, Subnet, IGW, NGW
# VPC CIDR
variable "vpc_cidr" {
  description = "VPC 구성"
  type = string
}

# Public Subnet 목록
variable "public_subnets" {}

# Private Subnet 목록
variable "web_subnets" {}
variable "app_subnets" {}
variable "db_subnets" {}

# cidr_block 지정 -> "0.0.0.0/0"
variable "cidr_blocks" {}

# SG----------------------------------------------------
variable "ingress_rule" {}
variable "egress_rule" {}

# ALB----------------------------------------------------
variable "alb_web_name" {}
variable "alb_app_name" {}
variable "tg_web_name" {}
variable "tg_app_name" {}

variable "health_checks" {
  type = map(object({
    path                 = string
    matcher              = string
    interval             = number
    timeout              = number
    healthy_threshold    = number
    unhealthy_threshold  = number
  }))
  description = "Health check settings for the load balancer target group"
}

# ASG----------------------------------------------------
variable "template_web_name" {}
variable "template_app_name" {}
variable "ami_id" {}
variable "instance_type" {}

variable "metadata_options" {
  type = map(object({
    http_endpoint               = string
    http_tokens                 = string
    http_put_response_hop_limit = number
    instance_metadata_tags      = string
  }))
  description = "metadata_options for ASG launch template"
}

variable "asg_web_name" {}
variable "asg_app_name" {}

# DB
variable "rds_db" {
  type = object({
    allocated_storage      = number
    db_name                = string
    engine                 = string
    engine_version         = string
    instance_class         = string
    parameter_group_name   = string
    multi_az               = bool
    skip_final_snapshot    = bool
    identifier             = string
  })
}

variable "db_user" {
  type = object({
    db_username            = string
    db_password            = string
  })
}

# ECS----------------------------------------------------
variable "ecs_cluster_name" {
  type    = string
  description = "ecs cluster name"
}