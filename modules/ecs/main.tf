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

locals {
  name = "claster-1"
}

resource "aws_ecs_cluster" "cluster1" {
  name = local.name
}

resource "aws_ecs_cluster_capacity_providers" "cluster1_capacity_providers" {
  cluster_name       = local.name
  capacity_providers = ["FARGATE"]

  default_capacity_provider_strategy {
    base              = 1
    weight            = 100
    capacity_provider = "FARGATE"
  }
}

resource "aws_ecs_task_definition" "cluster-task1" {
  family                   = "cluster-task"
  requires_compatibilities = ["FARGATE"]
  cpu                      = 256
  memory                   = 512
  network_mode             = "awsvpc"
  container_definitions = jsonencode([
    {
      name      = "nginx"
      image     = "nginx"
      cpu       = 10
      memory    = 512
      essential = true
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
        }
      ]
    }
  ])
  runtime_platform {
    operating_system_family = "LINUX"
    cpu_architecture        = "X86_64"
  }
}

resource "aws_default_vpc" "default_vpc" {
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default_vpc.id]
  }
}

resource "aws_ecs_service" "service" {
  name            = "nginx-service"
  cluster         = local.name
  task_definition = aws_ecs_task_definition.cluster-task1.arn
  desired_count   = 0

  network_configuration {
    subnets = toset(data.aws_subnets.default_subnets.ids)
  }
}
