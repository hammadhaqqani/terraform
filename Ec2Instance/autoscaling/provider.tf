provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket = "terraform-xme"
    key    = "asg/terraform.tfstate"
    region = "us-west-2"
  }
}