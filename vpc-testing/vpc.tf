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

resource "aws_db_subnet_group" "expense" {
  name       = "${var.project_name}-${var.environment}"
  subnet_ids = module.vpc.database_subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}"
    }
  )
}