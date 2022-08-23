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

module "codedeploy" {
  source = "../../modules/codedeploy"

  name                   = "test"
  autoscaling_group_name = "web-front"
  target_group_name      = "yamada-test"
}

