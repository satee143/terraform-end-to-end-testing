/*resource "aws_ssm_parameter" "sg-sql" {
  name  = "/${var.project_name}/${var.environment}/sg_sql"
  type  = "String"
  value = module.sg-sql.sg_id
}

resource "aws_ssm_parameter" "sg-bastion" {
  name  = "/${var.project_name}/${var.environment}/sg_bastion"
  type  = "String"
  value = module.sg-bastion.sg_id
}

resource "aws_ssm_parameter" "sg-backend-alb" {
  name  = "/${var.project_name}/${var.environment}/sg_backend_alb"
  type  = "String"
  value = module.sg-backend-alb.sg_id
}

resource "aws_ssm_parameter" "sg-frontend-alb" {
  name  = "/${var.project_name}/${var.environment}/sg_frontend_alb"
  type  = "String"
  value = module.sg-frontend-alb.sg_id
}

resource "aws_ssm_parameter" "sg-frontend" {
  name  = "/${var.project_name}/${var.environment}/sg_frontend"
  type  = "String"
  value = module.sg-frontend.sg_id
}*/