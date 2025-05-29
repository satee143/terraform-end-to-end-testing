resource "aws_instance" "bastion" {
  ami = "ami-09c813fb71547fc4f"
  instance_type = "t3.micro"
  #key_name      = "aws.pem"
  vpc_security_group_ids = [data.aws_ssm_parameter.sg_bastion.value]
  subnet_id = local.public_subnet_id
  #user_data = file("userdata.sh")
  tags = merge(var.common_tags, {
    Name = "${local.resource_name}-bastion"
  })
}

resource "aws_instance" "openvpn" {
  #OpenVPN Access Server Community Image-fe8020db-5343-4c43-9e65-5ed4a825c931
  # SSH login openvpnas
  # client login openvpn Openvpn@123
  #ami = "ami-06e5a963b2dadea6f"
  key_name  = aws_key_pair.openvpnas.key_name
  ami       = data.aws_ami.openvpn.id
  instance_type = "t3.micro"
  #key_name      = "aws.pem"
  vpc_security_group_ids = [data.aws_ssm_parameter.sg_openvpn.value]
  subnet_id = local.public_subnet_id
  user_data = file("userdata.sh")
  tags = merge(var.common_tags, {
    Name = "${local.resource_name}-vpn"
  })
}

resource "aws_key_pair" "openvpnas" {
  key_name = "aws"
  public_key = file("/Users/satheeshdoosa/PycharmProjects/terraform-end-to-end-testing/ec2/aws.pub")
}

output "vpn_ip" {
  value = aws_instance.openvpn.public_ip
}