data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}
data "aws_ssm_parameter" "sg_id" {
  name = "/${var.project_name}/${var.environment}/sg_backend"
}

data "aws_ssm_parameter" "private_subnet_ids" {
  name = split(",", "/${var.project_name}/${var.environment}/private-subnet-ids")

}
