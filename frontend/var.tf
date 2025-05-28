variable "project_name" {
  type    = string
  default = "dashboard"
}
variable "environment" {
  type    = string
  default = "dev"
}
variable "common_tags" {
  default = {
    "project_name" = "dashboard"
    "environment"  = "dev"
    terraform      = true
  }
}

variable "description" {
  type    = string
  default = "Launch template version 1 for Dashboard"
}

variable "instance_type" {
  type    = string
  default = "t3.micro"
}
variable "protocol" {
  type    = string
  default = "HTTP"
}

variable "port_number" {
  type    = number
  default = 80
}

variable "zone_id" {
    default = "Z01636753AQD82KILUFMZ"
}

variable "domain_name" {
    default = "devopsguide.store"
}
