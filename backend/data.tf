data "aws_ssm_parameter" "vpc_id" {
  name = "/${var.project_name}/${var.environment}/vpc_id"
}
data "aws_ssm_parameter" "sg_id" {
  name = "/${var.project_name}/${var.environment}/sg_backend"
}
data "aws_ssm_parameter" "sg_alb" {
  name = "/${var.project_name}/${var.environment}/sg_backend_alb"
}


data "aws_ssm_parameter" "private_subnet_ids" {
  name = "/${var.project_name}/${var.environment}/private-subnet-ids"

}

data "aws_ami" "joindevops" {
    most_recent      = true
    owners           = ["973714476881"]
    filter {
        name   = "name"
        values = ["RHEL-9-DevOps-Practice"]
    }

    filter {
        name   = "root-device-type"
        values = ["ebs"]
    }

    filter {
        name   = "virtualization-type"
        values = ["hvm"]
    }
}
