terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "ap-northeast-1"
}

resource "aws_instance" "app_server" {
  # amazon linux2のami
  ami           = "ami-0b7546e839d7ace12"
  instance_type = var.instance_type

  tags = {
    Name = var.instance_name
  }
}
