terraform {
  backend "s3" {
    bucket = "delta-terraform-test-bucket"
    region = "ap-northeast-1"
    key    = "codepipeline/ec2.terraform.tfstate"
  }
}