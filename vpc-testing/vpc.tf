module "vpc" {
  source = "git::https://github.com/satee143/terraform-end-to-end.git?ref=main"
  vpc_cidr_block=var.vpc_cidr_block
  enable_dns_hostnames=var.enable_dns_hostnames
  common_tags=var.common_tags
  vpc_tags=var.vpc_tags

}