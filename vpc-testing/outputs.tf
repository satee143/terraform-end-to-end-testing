output "eip" {
  value = module.vpc.eip                                     # The actual value to be outputted
  description = "The public IP address of the EC2 instance" # Description of what this output represents
}