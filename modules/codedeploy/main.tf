provider "aws" {
  region = "ap-northeast-1"
}

locals {
  name               = var.name
  autoscaling_groups = var.autoscaling_group_name
  target_group_name  = var.target_group_name
}

resource "aws_codedeploy_app" "app" {
  compute_platform = "Server"
  name             = local.name
}

resource "aws_iam_role" "appRole" {
  name = "${local.name}-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.appRole.name
}

resource "aws_codedeploy_deployment_group" "app" {
  app_name              = aws_codedeploy_app.app.name
  deployment_group_name = "${local.name}-group"
  service_role_arn      = aws_iam_role.appRole.arn

  deployment_style {
    deployment_type   = "BLUE_GREEN"
    deployment_option = "WITH_TRAFFIC_CONTROL"
  }

  autoscaling_groups = [local.autoscaling_groups]

  load_balancer_info {
    target_group_info {
      name = local.target_group_name
    }
  }

  blue_green_deployment_config {
    deployment_ready_option {
      action_on_timeout    = "STOP_DEPLOYMENT"
      wait_time_in_minutes = 60
    }

    green_fleet_provisioning_option {
      action = "DISCOVER_EXISTING"
    }

    terminate_blue_instances_on_deployment_success {
      action = "KEEP_ALIVE"
    }
  }

}

output "codedeploy_app_name" {
  value = aws_codedeploy_app.app.name
}

output "codedeploy_group_name" {
  value = aws_codedeploy_deployment_group.app.app_name
}
