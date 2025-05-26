data "aws_ssm_parameter" "sg_bastion" {
  name = "/${var.project_name}/${var.environment}/sg_bastion"
}


data "aws_ssm_parameter" "public_subnet_id" {
  name = "/${var.project_name}/${var.environment}/public-subnet-ids"
}

data "aws_ssm_parameter" "sg_openvpn" {
  name = "/${var.project_name}/${var.environment}/sg_openvpn"
}

data "aws_ami" "openvpn" {
  most_recent = true
  owners = ["679593333241"]
  filter {
    name = "name"
    values = ["OpenVPN Access Server Community Image-fe8020db-*"]
  }

  filter {
    name = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name = "virtualization-type"
    values = ["hvm"]
  }
}