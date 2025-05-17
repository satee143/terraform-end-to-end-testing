module "vpc" {
  source                = "git::https://github.com/satee143/terraform-end-to-end.git?ref=main"
  vpc_cidr_block        = var.vpc_cidr_block
  enable_dns_hostnames  = var.enable_dns_hostnames
  common_tags           = var.common_tags
  project_name          = var.project_name
  environment           = var.environment
  public_subnet_cidrs   = var.public_subnet_cidrs
  private_subnet_cidrs  = var.private_subnet_cidrs
  database_subnet_cidrs = var.database_subnet_cidrs
}