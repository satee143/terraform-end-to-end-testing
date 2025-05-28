terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.94.0"
    }
  }
  backend "s3" {
    bucket         = "terraform-module-testing-aws"
    region         = "us-east-1"
    key            = "frontend-statefile-new"
    dynamodb_table = "myredbucket222"
    #use_lockfile = "true"
  }
}

provider "aws" {
  region = "us-east-1"
}