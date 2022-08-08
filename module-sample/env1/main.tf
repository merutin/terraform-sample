terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "ap-northeast-1"
}

module "vpc" {
  source   = "../../modules/vpc"
  system   = "test"
  env      = "dev"
  cidr_vpc = "10.255.0.0/16"
  cidr_public = [
    "10.255.1.0/24",
    "10.255.2.0/24"
  ]
}