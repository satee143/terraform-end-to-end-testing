locals {
  resource_name = "${var.project_name}-${var.environment}"
  sg_backend    = data.aws_ssm_parameter.sg_id.value
  vpc_id=data.aws_ssm_parameter.vpc_id.value
  private_subnets=data.aws_ssm_parameter.private_subnet_ids.value
}