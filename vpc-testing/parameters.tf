resource "aws_ssm_parameter" "vpc_id" {
  name  = "/${var.project_name}/${var.environment}/vpc_id"
  type  = "String"
  value = module.vpc.vpc_id
}

resource "aws_ssm_parameter" "public_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/public-subnet-ids"
  type = "StringList"
  value = join(",", module.vpc.public_subnet_ids)
}

resource "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private-subnet-ids"
  type = "StringList"
  value = join(",", module.vpc.private_subnet_ids)
}

resource "aws_ssm_parameter" "database_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/database-subnet-ids"
  type = "StringList"
  value = join(",", module.vpc.database_subnet_ids)
}

resource "aws_ssm_parameter" "public_route-table-id" {
  name  = "/${var.project_name}/${var.environment}/public-route-table_id"
  type  = "String"
  value = module.vpc.public-route-table_id
}

resource "aws_ssm_parameter" "private_route-table-id" {
  name  = "/${var.project_name}/${var.environment}/private-route-table_id"
  type  = "String"
  value = module.vpc.private-route-table_id
}

resource "aws_ssm_parameter" "database_route-table-id" {
  name  = "/${var.project_name}/${var.environment}/database-route-table_id"
  type  = "String"
  value = module.vpc.database-route-table_id
}

resource "aws_ssm_parameter" "elastic_ip_id" {
  name  = "/${var.project_name}/${var.environment}/eip_id"
  type  = "String"
  value = module.vpc.eip_id
}

resource "aws_ssm_parameter" "elastic_ip_public_ip" {
  name  = "/${var.project_name}/${var.environment}/elastic_ip_public_ip"
  type  = "String"
  value = module.vpc.eip_ip
}
resource "aws_ssm_parameter" "nat_gateway_id" {
  name  = "/${var.project_name}/${var.environment}/nat_gateway_id"
  type  = "String"
  value = module.vpc.nat_gateway
}
