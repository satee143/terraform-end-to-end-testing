locals {
  resource_name           = "${var.project_name}-${var.environment}"
  sg_frontend             = data.aws_ssm_parameter.sg_id.value
  sg_alb_frontend         = data.aws_ssm_parameter.sg_alb.value
  vpc_id                  = data.aws_ssm_parameter.vpc_id.value
  public_subnets = split(",", data.aws_ssm_parameter.public_subnet_ids.value)
  public_subnet_id        = split(",", data.aws_ssm_parameter.public_subnet_ids.value)[0]
  web_alb_certificate_arn = data.aws_ssm_parameter.web_alb_certificate_arn.value
}