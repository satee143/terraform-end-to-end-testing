variable "project_name" {
  type = string
  default = "dashboard"
}
variable "environment" {
  type = string
  default = "dev"
}
variable "common_tags" {
  default = {
    "project_name" = "dashboard"
    "environment"  = "dev"
    terraform      = true
  }
}
variable "sg_name" {}