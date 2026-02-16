
##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "default" {
  tags = {
    Name = "usw2-dev1"
  }
}

data "aws_subnets" "all" {
  vpc_id = data.aws_vpc.default.id
}

data "aws_subnet" "all" {
  for_each = data.aws_subnets.all.ids
  id       = each.value
}

data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = "default"
}

#####
# DB
#####
module "db" {
  source = "terraform-aws-modules/rds/aws"

  identifier = var.identifier

  engine            = "sqlserver-ex"
  engine_version    = "14.00.1000.169.v1"
  instance_class    = var.instanceclass
  allocated_storage = 20
  storage_encrypted = false

  name     = var.rdsname
  username = var.username
  password = var.password
  port     = "1433"

  vpc_security_group_ids = ["${data.aws_security_group.default.id}"]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  # disable backups to create DB faster
  backup_retention_period = 0

  tags = {
    Name            = var.identifier
    Role            = var.role
    XMCC            = var.xmcc
    APPNAME         = var.appname
    DeploymentState = var.dpstate
  }


  # DB subnet group
  subnet_ids = data.aws_subnets.all.ids

  # Snapshot name upon DB deletion
  final_snapshot_identifier = var.identifier

  create_db_parameter_group = false
  license_model             = "license-included"

  timezone = "Central Standard Time"

  # Database Deletion Protection
  deletion_protection = false

  # DB options
  major_engine_version = "14.00"

  options = []
}









