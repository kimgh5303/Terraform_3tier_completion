provider "aws" {
  region  = var.region
}

# 모듈 정의 - variables.tf에 있는 변수명
# 각 모듈에 있는 변수값은 child로 보내짐
# VPC, Subnet, IGW, NGW
module "vpc" {
  source = "./modules/vpc"      # 모듈 코드가 위치한 경로 지정
  tags     = var.tags

  vpc_cidr        = var.vpc_cidr
  public_subnets  = var.public_subnets
  web_subnets     = var.web_subnets
  app_subnets     = var.app_subnets
  db_subnets      = var.db_subnets
  rt_cidr_blocks  = var.cidr_blocks
}

module "sg" {
  source   = "./modules/sg"
  tags     = var.tags
  vpc_id   = module.vpc.vpc_id

  ingress_rule = var.ingress_rule
  egress_rule = var.egress_rule
}

module "alb" {
  source   = "./modules/alb"
  tags     = var.tags
  vpc_id   = module.vpc.vpc_id

  alb_web_sg = module.sg.alb_web_sg
  alb_app_sg = module.sg.alb_app_sg

  public_subnet_ids = module.vpc.public_subnet_ids
  app_subnet_ids = module.vpc.app_subnet_ids

  alb_web_name = var.alb_web_name
  alb_app_name = var.alb_app_name
  tg_web_name = var.tg_web_name
  tg_app_name = var.tg_app_name
  
  health_checks = var.health_checks
}

module "asg" {
  source    = "./modules/asg"
  tags      = var.tags

  alb_web_sg = module.sg.alb_web_sg
  alb_app_sg = module.sg.alb_app_sg
  alb_web_dns = module.alb.alb_web_dns
  alb_web = module.alb.alb_web
  tg_web = module.alb.tg_web
  tg_app = module.alb.tg_app
  web_subnet_ids = module.vpc.web_subnet_ids
  app_subnet_ids = module.vpc.app_subnet_ids

  template_web_name = var.template_web_name
  template_app_name = var.template_app_name
  ami_id    = var.ami_id
  instance_type = var.instance_type
  metadata_options = var.metadata_options
  asg_web_name = var.asg_web_name
  asg_app_name = var.asg_app_name
  
  db_subnet_grp = module.vpc.db_subnet_grp
  db_sg = module.sg.db_sg
  rds_db    = var.rds_db
  db_user = var.db_user

  ecs_cluster_name = var.ecs_cluster_name
}

module "ecs" {
  source   = "./modules/ecs"
  tags     = var.tags
  az_1    = var.az_1
  az_2    = var.az_2
  
  alb_app_dns = module.alb.alb_app_dns

  rds_endpoint = module.asg.rds_endpoint
  db_user = var.db_user
  rds_db    = var.rds_db

  tg_web = module.alb.tg_web
  tg_app = module.alb.tg_app

  asg_web_arn = module.asg.asg_web_arn
  asg_app_arn = module.asg.asg_app_arn
  
  web_subnet_ids = module.vpc.web_subnet_ids
  app_subnet_ids = module.vpc.app_subnet_ids
}