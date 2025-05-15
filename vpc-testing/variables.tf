variable "vpc_cidr_block" {
  type = string                     # The type of the variable, in this case a string
  default = "10.0.0.0/16"              # Default value for the variable

}
variable "enable_dns_hostnames" {
  type = string                     # The type of the variable, in this case a string
  default = true             # Default value for the variable

}
variable "common_tags" {
  default = {
    "project_name" = "dashboard"
    "environment"  = "dev"
    terraform      = true
  }
}

variable "project_name" {
  default = "dashboard"
}
variable "environment" {
  default = "dev"
}