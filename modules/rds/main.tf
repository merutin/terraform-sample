provider "aws" {
  region = "ap-northeast-1"

  default_tags {
    tags = {
      HashiCorpLearnTutorial = "rds-upgrade"
    }
  }
}

data "aws_availability_zones" "available" {}

resource "aws_default_vpc" "default_vpc" {
}

data "aws_subnets" "default_subnets" {
  filter {
    name   = "vpc-id"
    values = [aws_default_vpc.default_vpc.id]
  }
}

resource "random_pet" "name" {
  length = 1
}

resource "aws_db_subnet_group" "example" {
  name       = "${random_pet.name.id}-example"
  subnet_ids = toset(data.aws_subnets.default_subnets.ids)

  tags = {
    Name = "example"
  }
}

resource "aws_security_group" "rds" {
  name   = "${random_pet.name.id}_example_rds"
  vpc_id = aws_default_vpc.default_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "example_rds"
  }
}

resource "aws_rds_cluster" "example" {
  cluster_identifier          = "${random_pet.name.id}-demo-sls"
  engine                      = "aurora-mysql"
  engine_mode                 = "provisioned"
  engine_version              = "8.0.mysql_aurora.3.02.0"
  # engine_version              = "5.7.mysql_aurora.2.10.2"
  availability_zones          = data.aws_availability_zones.available.names
  database_name               = "mydb"
  master_username             = "foo"
  master_password             = "foobarhoge"
  db_subnet_group_name        = aws_db_subnet_group.example.name
  skip_final_snapshot         = true
  allow_major_version_upgrade = true
  apply_immediately           = true
  # snapshot_identifier         = "pheasant-demo"
  serverlessv2_scaling_configuration {
    min_capacity = 0.5
    max_capacity = 1
  }
}

# resource "aws_rds_cluster_instance" "example" {
#   count                   = 1
#   cluster_identifier      = aws_rds_cluster.example.id
#   identifier              = "${random_pet.name.id}-80-instance-${count.index}"
#   engine                  = aws_rds_cluster.example.engine
#   engine_version          = aws_rds_cluster.example.engine_version
#   instance_class          = "db.t3.medium"
#   db_subnet_group_name    = aws_db_subnet_group.example.name
#   db_parameter_group_name = aws_db_parameter_group.example.name
#   publicly_accessible     = false
#   apply_immediately       = true
# }

resource "aws_rds_cluster_instance" "serverless" {
  count                   = 1
  cluster_identifier      = aws_rds_cluster.example.id
  identifier              = "${random_pet.name.id}-80-sls-instance-${count.index}"
  engine                  = aws_rds_cluster.example.engine
  engine_version          = aws_rds_cluster.example.engine_version
  instance_class          = "db.serverless"
  db_subnet_group_name    = aws_db_subnet_group.example.name
  db_parameter_group_name = aws_db_parameter_group.example.name
  publicly_accessible     = false
  apply_immediately       = true
}

resource "aws_db_parameter_group" "example" {
  name   = "${random_pet.name.id}-80-parameter"
  # family = "aurora-mysql5.7"
  family = "aurora-mysql8.0"
}
