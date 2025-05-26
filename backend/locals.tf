locals {
  resource_name = "${var.project_name}-${var.environment}"
  sg_backend    = data.aws_ssm_parameter.sg_id.value
  sg_alb_backend    = data.aws_ssm_parameter.sg_alb.value
  vpc_id=data.aws_ssm_parameter.vpc_id.value
  private_subnets=split(",",data.aws_ssm_parameter.private_subnet_ids.value)
  private_subnet_id = split(",", data.aws_ssm_parameter.private_subnet_ids.value)[0]
}