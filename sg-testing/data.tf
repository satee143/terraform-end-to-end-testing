data "aws_ssm_parameter" "vpc_d" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
}