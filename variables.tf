variable "region-name" {
  description = "Region name"
}

variable "vpc-cidr-block" {
  description = "CIDR Block for VPC"
}

variable "vpc-name" {
  description = "Name for Virtual Private Cloud"
}

variable "igw-name" {
  description = "Name for Internet Gateway"
}

variable "nat-gw-name1" {
  description = "Name for NAT Gateway1"
}
variable "nat-gw-name2" {
  description = "Name for NAT Gateway2"
}

variable "public-subnet1-cidr" {
  description = "CIDR Block for Web-tier Subnet-1"
}

variable "public-subnet1-name" {
  description = "Name for Web-tier Subnet-1"
}

variable "public-subnet2-cidr" {
  description = "CIDR Block for Web-tier Subnet-2"
}

variable "public-subnet2-name" {
  description = "Name for Web-tier Subnet-2"
}


# Prefix
variable "web-prefix" {
  description = "Name for prod Prefix name" 
  default = "web"
}
variable "app-prefix" {
  description = "Name for prod Prefix name" 
  default = "app"
}
variable "dev-prefix" {
  description = "Name for dev Prefix name"
}

variable "test-prefix" {
  description = "Name for test Prefix name"
}

variable "prod-prefix" {
  description = "Name for prod Prefix name" 
}

# Tags
variable "owner-tag" {
  description = "Name for Owner tag name"
}

## WEB
variable "web-subnet1-cidr" {
  description = "CIDR Block for Application-tier Subnet-1"
}

variable "web-subnet1-name" {
  description = "Name for app-tier Subnet-1"
}

variable "web-subnet2-cidr" {
  description = "CIDR Block for Application-tier Subnet-2"
}

variable "web-subnet2-name" {
  description = "Name for Application-tier Subnet-2"
}

## WAS
variable "app-subnet1-cidr" {
  description = "CIDR Block for Application-tier Subnet-1"
}

variable "app-subnet1-name" {
  description = "Name for Application-tier Subnet-1"
}

variable "app-subnet2-cidr" {
  description = "CIDR Block for Application-tier Subnet-2"
}

variable "app-subnet2-name" {
  description = "Name for Application-tier Subnet-2"
}


## DB
variable "db-subnet1-cidr" {
  description = "CIDR Block for Database-tier Subnet-1"
}

variable "db-subnet1-name" {
  description = "Name for Database-tier Subnet-1"
}

variable "db-subnet2-cidr" {
  description = "CIDR Block for Database-tier Subnet-2"
}

variable "db-subnet2-name" {
  description = "Name for Database-tier Subnet-2"
}

variable "az-1" {
  description = "Availabity Zone 1"
}

variable "az-2" {
  description = "Availabity Zone 2"
}

variable "public-rt-name" {
  description = "Name for Public Route table"
}

variable "private-rt-name1" {
  description = "Name for Private Route table1"
}
variable "private-rt-name2" {
  description = "Name for Private Route table2"
}

variable "launch-template-web-name" {}

variable "image-id" {
  description = "Value for Image-id"
}

variable "instance-type" {}

#variable "key-name" {
#  description = "Value for Key name"
#}

variable "web-instance-name" {}

variable "alb-web-name" {}

variable "alb-sg-web-name" {}

variable "asg-web-name" {}

variable "asg-sg-web-name" {}

variable "tg-web-name" {}

variable "launch-template-app-name" {}

variable "app-instance-name" {}

variable "alb-app-name" {}

variable "alb-sg-app-name" {}

variable "asg-app-name" {}

variable "asg-sg-app-name" {}

variable "tg-app-name" {}

variable "db-username" {}

variable "db-password" {}

variable "db-name" {}

variable "instance-class" {}

variable "db-sg-name" {}

variable "db-subnet-grp-name" {}

variable "app-db-sg-name" {}

# IAM role
variable "ecs_task_execution_role" {}
variable "ecs-instance-role" {}
variable "ecs-service-role" {}

# ECS
variable "ecs-cluster-name" {}

variable "ecs-capacity-provider" {}

variable "ecs-ecr" {}

variable "ecs-task-definition"{}

variable "ecs-family-name" {}

variable "ecs-service-name" {}

# cloudwatch
variable "retention_in_days" {}