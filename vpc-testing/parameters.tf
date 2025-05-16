resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/public-subnet-ids"
  type  = "StringList"
  value = join(",", module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/private-subnet-ids"
  type  = "StringList"
    value = join(",", module.vpc.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name  = "/${var.project_name}/${var.environment}/database-subnet-ids"
  type  = "StringList"
    value = join(",", module.vpc.database_subnet_ids)
}

resource "aws_ssm_parameter" "public_route-table-id" {
  name  = "/${var.project_name}/${var.environment}/public-route-table_id"
  type  = "String"
    value = module.vpc.public-route-table_id.id
}

resource "aws_ssm_parameter" "rivate_route-table-id" {
  name  = "/${var.project_name}/${var.environment}/private-route-table_id"
  type  = "String"
    value = module.vpc.private-route-table_id.id
}