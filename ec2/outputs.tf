output "instance_public_ip" {
  value     = aws_instance.bastion
  sensitive = true
}