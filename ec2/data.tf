data "aws_ssm_parameter" "sg_bastion" {
  name = "/${var.project_name}/${var.environment}/sg_bastion"
}

data "aws_ssm_parameter" "public_subnet_id" {
  name = "/${var.project_name}/${var.environment}/public-subnet-ids"
}