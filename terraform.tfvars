## REGION & Network 
region-name              = "ap-northeast-2"
az-1                     = "ap-northeast-2a"
az-2                     = "ap-northeast-2c"

vpc-cidr-block           = "10.0.0.0/16"
vpc-name                 = "kgh-three-tier-vpc"
igw-name                 = "kgh-three-tier-igw"
nat-gw-name1              = "kgh-three-tier-nat-gw1"
nat-gw-name2              = "kgh-three-tier-nat-gw2"

## CIDR
public-subnet1-cidr         = "10.0.1.0/24"
public-subnet1-name         = "kgh-three-tier-public-subnet1"
public-subnet2-cidr         = "10.0.2.0/24"
public-subnet2-name         = "kgh-three-tier-public-subnet2"

## WEB
web-subnet1-cidr         = "10.0.3.0/24"
web-subnet1-name         = "kgh-three-tier-web-subnet-1"
web-subnet2-cidr         = "10.0.4.0/24"
web-subnet2-name         = "kgh-three-tier-web-subnet-2"

## WAS
app-subnet1-cidr         = "10.0.5.0/24"
app-subnet1-name         = "kgh-three-tier-app-subnet-1"
app-subnet2-cidr         = "10.0.6.0/24"
app-subnet2-name         = "kgh-three-tier-app-subnet-2"

## DB
db-subnet1-cidr          = "10.0.7.0/24"
db-subnet1-name          = "kgh-three-tier-db-subnet-1"
db-subnet2-cidr          = "10.0.8.0/24"
db-subnet2-name          = "kgh-three-tier-db-subnet-2"

## AZ & Routing Table
public-rt-name           = "kgh-three-tier-public-route-table"
private-rt-name1         = "kgh-three-tier-private-route-table1"
private-rt-name2         = "kgh-three-tier-private-route-table2"


launch-template-web-name = "kgh-three-tier-launch-template-web"
image-id                 = "ami-0d070dfaaef6e355c" # al2023-ami-ecs-hvm-2023.0.20240430-kernel-6.1-x86_64     ecs-optimized ami
instance-type            = "t2.micro"


## Tag name

#key-name                 = "3tier-key"
web-instance-name        = "kgh-three-tier-web-instances"
alb-web-name             = "kgh-three-tier-alb-web"
alb-sg-web-name          = "kgh-three-tier-alb-sg-web"
asg-web-name             = "kgh-three-tier-asg-web"
asg-sg-web-name          = "kgh-three-tier-asg-sg-web"
tg-web-name              = "kgh-three-tier-tg-web"
launch-template-app-name = "kgh-three-tier-launch-template-app"
app-instance-name        = "kgh-three-tier-app-instances"
alb-app-name             = "kgh-three-tier-alb-app"
alb-sg-app-name          = "kgh-three-tier-alb-sg-app"
asg-app-name             = "kgh-three-tier-asg-app"
asg-sg-app-name          = "kgh-three-tier-asg-sg-app"
tg-app-name              = "kgh-three-tier-tg-app"
db-name                  = "mydb"

instance-class           = "db.t3.micro"  # db 인스턴스 타입
db-sg-name               = "kgh-three-tier-db-sg"
db-subnet-grp-name       = "kgh-three-tier-db-subnet-grp"
app-db-sg-name           = "kgh-three-tier-app-db"

# iam role 이름
ecs_task_execution_role = "kgh-ecs-taskExecutionRole"
ecs-instance-role = "kgh-ecs-instanceRole"
ecs-service-role = "kgh-ecs-serviceRole"

# 태그 설정(name, mark, environment)
owner-tag = "kgh"

#prefix 설정
dev-prefix = "dev"
test-prefix = "test"
prod-prefix = "prod"

web-prefix = "web"
app-prefix = "app"

# ECS Cluster Settings
ecs-cluster-name = "ecs-cluster"
ecs-capacity-provider = "ecs-capacity-provider"
ecs-ecr = "ecs-ecr"
ecs-task-definition = "ecs-task-def"
ecs-family-name = "ecs-family"
ecs-service-name = "ecs-service"

# cloudwatch
retention_in_days = 30 # 로그 보관 기간. 이후 삭제