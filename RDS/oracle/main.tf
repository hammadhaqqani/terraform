
##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "default" {
  tags = {
    Name = "usw2-dev1"
  }
}

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

data "aws_subnet" "all" {
  for_each = toset(data.aws_subnets.all.ids)
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
  source  = "terraform-aws-modules/rds/aws"
  version = "~> 5.0"

  identifier = var.identifier

  engine            = "oracle-ee"
  engine_version    = "12.1.0.2.v8"
  instance_class    = var.instanceclass
  allocated_storage = 10
  storage_encrypted = false
  license_model     = "bring-your-own-license"

  db_name                             = var.rdsname
  username                            = var.username
  password                            = var.password
  port                                = "1521"
  iam_database_authentication_enabled = false

  vpc_security_group_ids = [data.aws_security_group.default.id]

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window      = "03:00-06:00"

  multi_az = true

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

  # DB parameter group
  family = "oracle-ee-12.1"

  # DB option group
  major_engine_version = "12.1"

  # Snapshot name upon DB deletion
  final_snapshot_identifier_prefix = var.identifier

  # See here for support character sets https://docs.aws.amazon.com/AmazonRDS/latest/UserGuide/Appendix.OracleCharacterSets.html
  character_set_name = "AL32UTF8"

  # Database Deletion Protection
  deletion_protection = false
}





