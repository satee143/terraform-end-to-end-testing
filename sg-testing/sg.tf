module "sg-sql" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id.value
  description  = "security group for my sql"
  sg_name      = "mysql"
}

module "sg-bastion" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id.value
  description  = "security group for my bastion"
  sg_name      = "bastion"
}

module "sg-openvpn" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id.value
  description  = "security group for my openvpn"
  sg_name      = "openvpn"
}

module "sg-backend-alb" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id.value
  description  = "security group for backend alb"
  sg_name      = "backend-alb"
}

module "sg-frontend-alb" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id.value
  description  = "security group for frontend alb"
  sg_name      = "frontend-alb"
}

module "sg-frontend" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id.value
  description  = "security group for frontend"
  sg_name      = "frontend"
}

module "sg-backend" {
  source       = "git::https://github.com/satee143/terraform-security-group-module.git?ref=main"
  project_name = var.project_name
  environment  = var.environment
  common_tags  = var.common_tags
  vpc_id       = data.aws_ssm_parameter.vpc_id.value
  description  = "security group for backend"
  sg_name      = "backend"
}

resource "aws_security_group_rule" "bastion-ingress" {
  type              = "ingress"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = module.sg-bastion.sg_id
  to_port           = 22
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "frontend-elb-http-ingress" {
  type              = "ingress"
  from_port         = 80
  protocol          = "tcp"
  security_group_id = module.sg-frontend-alb.sg_id
  to_port           = 80
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "frontend-elb-https-ingress" {
  type              = "ingress"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = module.sg-frontend-alb.sg_id
  to_port           = 443
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "frontend-elb-to-frontend-ingress" {
  type                     = "ingress"
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = module.sg-frontend.sg_id
  to_port                  = 80
  source_security_group_id = module.sg-frontend-alb.sg_id
}

resource "aws_security_group_rule" "frontend-to-backend-alb-ingress" {
  type                     = "ingress"
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = module.sg-backend-alb.sg_id
  to_port                  = 80
  source_security_group_id = module.sg-frontend.sg_id
}

resource "aws_security_group_rule" "backend-alb-to-backend-ingress" {
  type                     = "ingress"
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = module.sg-backend.sg_id
  to_port                  = 80
  source_security_group_id = module.sg-backend-alb.sg_id
}

resource "aws_security_group_rule" "backend-sql-ingress" {
  type                     = "ingress"
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = module.sg-sql.sg_id
  to_port                  = 3306
  source_security_group_id = module.sg-backend.sg_id
}

resource "aws_security_group_rule" "bastion-to-sql" {
  type                     = "ingress"
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = module.sg-sql.sg_id
  to_port                  = 3306
  source_security_group_id = module.sg-bastion.sg_id
}

resource "aws_security_group_rule" "openvpn-ingress-ssh" {
  type              = "ingress"
  from_port         = 22
  protocol          = "tcp"
  security_group_id = module.sg-openvpn.sg_id
  to_port           = 22
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "openvpn-ingress-https" {
  type              = "ingress"
  from_port         = 443
  protocol          = "tcp"
  security_group_id = module.sg-openvpn.sg_id
  to_port           = 443
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "openvpn-ingress-943" {
  type              = "ingress"
  from_port         = 943
  protocol          = "tcp"
  security_group_id = module.sg-openvpn.sg_id
  to_port           = 943
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "openvpn-ingress-1194" {
  type              = "ingress"
  from_port         = 1194
  protocol          = "tcp"
  security_group_id = module.sg-openvpn.sg_id
  to_port           = 1194
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "openvpn-to-sql" {
  type                     = "ingress"
  from_port                = 3306
  protocol                 = "tcp"
  security_group_id        = module.sg-sql.sg_id
  to_port                  = 3306
  source_security_group_id = module.sg-openvpn.sg_id
}

resource "aws_security_group_rule" "openvpn-backend" {
  type                     = "ingress"
  from_port                = 22
  protocol                 = "tcp"
  source_security_group_id = module.sg-openvpn.sg_id
  to_port                  = 22
  security_group_id        = module.sg-backend.sg_id
}

resource "aws_security_group_rule" "openvpn-to-backend-alb-ingress" {
  type                     = "ingress"
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = module.sg-backend-alb.sg_id
  to_port                  = 80
  source_security_group_id = module.sg-openvpn.sg_id
}

resource "aws_security_group_rule" "backend_vpn_http" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.sg-openvpn.sg_id
  security_group_id        = module.sg-backend.sg_id
}

resource "aws_security_group_rule" "backend_app_alb" {
  type                     = "ingress"
  from_port                = 8080
  to_port                  = 8080
  protocol                 = "tcp"
  source_security_group_id = module.sg-backend-alb.sg_id
  security_group_id        = module.sg-backend.sg_id
}

resource "aws_security_group_rule" "openvpn-frontend" {
  type                     = "ingress"
  from_port                = 22
  protocol                 = "tcp"
  source_security_group_id = module.sg-openvpn.sg_id
  to_port                  = 22
  security_group_id        = module.sg-frontend.sg_id
}


resource "aws_security_group_rule" "frontend_public" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  cidr_blocks = ["0.0.0.0/0"]
  security_group_id = module.sg-frontend.sg_id
}