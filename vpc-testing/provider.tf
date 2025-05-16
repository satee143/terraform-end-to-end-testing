terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.81.0"
    }
  }
  backend "s3" {
    bucket       = "terraform-module-testing-aws"
    region       = "us-east-1"
    key          = "vpc-statefile-new"
    dynamodb_table = "myredbucket222"
    #use_lockfile = "true"
  }
}
provider "aws" {
  region = "us-east-1"
}