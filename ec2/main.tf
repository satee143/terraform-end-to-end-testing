resource "aws_instance" "bastion" {
  ami = "ami-09c813fb71547fc4f"
  instance_type = "t3.micro"
  #key_name      = "aws.pem"
  vpc_security_group_ids = [data.aws_ssm_parameter.sg_bastion.value]
  subnet_id = local.public_subnet_id
  #user_data = file("userdata.sh")
  tags = merge(var.common_tags, {
    Name = local.resource_name
  })
}