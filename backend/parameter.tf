resource "aws_ssm_parameter" "launch_template_arn" {
  name  = "/${var.project_name}/${var.environment}/launch_template_arn"
  type  = "String"
  value = aws_launch_template.dashboard.arn
}
resource "aws_ssm_parameter" "launch_template_id" {
  name  = "/${var.project_name}/${var.environment}/launch_template_id"
  type  = "String"
  value = aws_launch_template.dashboard.id
}

