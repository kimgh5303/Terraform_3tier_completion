# 리전 정의
region = "ap-northeast-2"

# 공통 태그 이니셜
tags = {
  key                 = "owner"
  value               = "kgh"
  name = "owner:kgh"
}

az_1                     = "ap-southeast-1a"
az_2                     = "ap-southeast-1c"

# VPC----------------------------------------------------
vpc_cidr = "10.10.0.0/16"

# Public Subnets 정의
public_subnets = {
  pub_sub_1a = {
    zone = "ap-northeast-2a"
    cidr = "10.10.1.0/24"
  },
  pub_sub_1c = {
    zone = "ap-northeast-2c"
    cidr = "10.10.2.0/24"
  }
}

# Web Subnets 정의
web_subnets = {
  web_sub_1a = {
    zone = "ap-northeast-2a"
    cidr = "10.10.3.0/24"
  },
  web_sub_1c = {
    zone = "ap-northeast-2c"
    cidr = "10.10.4.0/24"
  }
}

# App Subnets 정의
app_subnets = {
  app_sub_1a = {
    zone = "ap-northeast-2a"
    cidr = "10.10.5.0/24"
  },
  app_sub_1c = {
    zone = "ap-northeast-2c"
    cidr = "10.10.6.0/24"
  }
}

# DB Subnets 정의
db_subnets = {
  db_sub_1a = {
    zone = "ap-northeast-2a"
    cidr = "10.10.7.0/24"
    map_public_ip_on_launch = false
  },
  db_sub_1c = {
    zone = "ap-northeast-2c"
    cidr = "10.10.8.0/24"
    map_public_ip_on_launch = false
  }
}

# cidr_block 지정 -> "0.0.0.0/0"
cidr_blocks = "0.0.0.0/0"

# SG----------------------------------------------------
ingress_rule = {
  http = {
    description = "HTTP from Internet"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  },
  https = {
    description = "HTTPS from Internet"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ssh = {
    description = "SSH From Anywhere or Your-IP"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  db = {
    description = "DB Port"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
  }
}

egress_rule = {
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

# ALB----------------------------------------------------
# Web, App health_check - target group
alb_web_name = "kgh-alb-web"
alb_app_name = "kgh-alb-app"
tg_web_name = "kgh-tg-web"
tg_app_name = "kgh-tg-app"

health_checks = {
  default = {
    path                 = "/"
    matcher              = "200-299"
    interval             = 5
    timeout              = 3
    healthy_threshold    = 3
    unhealthy_threshold  = 5
  }
}

# ASG----------------------------------------------------
# Web, App OS 이미지
template_web_name = "kgh-template-web"
template_app_name = "kgh-template-app"
ami_id = "ami-0dfabddd52dec98c7"
instance_type = "t2.micro"

# Web, App 인스턴스 안 메타데이터
metadata_options = {
  default = {
    http_endpoint               = "enabled"
    http_tokens                 = "required"
    http_put_response_hop_limit = 1
    instance_metadata_tags      = "enabled"
  }
}

asg_web_name = "kgh-asg-web"
asg_app_name = "kgh-asg-app"

# DB
rds_db = {
  "allocated_storage"      : 10
  "db_name"                : "mydb"
  "engine"                 : "mysql"
  "engine_version"         : "8.0"
  "instance_class"         : "db.t3.micro"
  "parameter_group_name"   : "default.mysql8.0"
  "multi_az"               : true
  "skip_final_snapshot"    : true
  "identifier"             : "my-rds-instance"
}

# ECS----------------------------------------------------
ecs_cluster_name = "ecs-cluster"

