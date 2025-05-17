module "sg-sql" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id
  description  = "security group for my sql"
  sg_name      = "mysql"
}

module "sg-bastion" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id
  description  = "security group for my bastion"
  sg_name      = "bastion"
}

module "sg-backend-alb" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id
  description  = "security group for backend alb"
  sg_name      = "backend-alb"
}

module "sg-frontend-alb" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id
  description  = "security group for frontend alb"
  sg_name      = "frontend-alb"
}

module "sg-frontend" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id
  description  = "security group for frontend"
  sg_name      = "frontend"
}