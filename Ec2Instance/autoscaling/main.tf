##############################
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

data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["137112412989"] # Amazon

  filter {
    name = "name"

    values = [
      "amzn-ami-hvm-*-x86_64-gp2",
    ]
  }

  filter {
    name = "owner-alias"

    values = [
      "amazon",
    ]
  }
}

resource "aws_iam_service_linked_role" "autoscaling" {
  aws_service_name = "autoscaling.amazonaws.com"
  description      = "A service linked role for autoscaling"
  custom_suffix    = "something"

  # Sometimes good sleep is required to have some IAM resources created before they can be used
  provisioner "local-exec" {
    command = "sleep 10"
  }
}

######
# Launch configuration and autoscaling group
######
module "example" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 3.0"

  name = "launch-configuration-amzlinux"

  # Launch configuration
  #
  # launch_configuration = "my-existing-launch-configuration" # Use the existing launch configuration
  # create_lc = false # disables creation of launch configuration
  lc_name = "Linux-lc"

  image_id                     = data.aws_ami.amazon_linux.id
  instance_type                = "t2.micro"
  security_groups              = [data.aws_security_group.default.id]
  associate_public_ip_address  = true
  recreate_asg_when_lc_changes = true

  ebs_block_device = [
    {
      device_name           = "/dev/xvdz"
      volume_type           = "gp2"
      volume_size           = "50"
      delete_on_termination = true
    },
  ]

  root_block_device = [
    {
      volume_size           = "50"
      volume_type           = "gp2"
      delete_on_termination = true
    },
  ]

  # Auto scaling group
  asg_name                  = "webserver-asg"
  vpc_zone_identifier       = data.aws_subnets.all.ids
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 0
  wait_for_capacity_timeout = 0
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn

  tags = [
    {
      Name            = var.hostname
      Role            = var.role
      XMCC            = var.xmcc
      APPNAME         = var.appname
      DeploymentState = var.dpstate
    },
    {
      key                 = "Project"
      value               = "IAC"
      propagate_at_launch = true
    },
  ]

  tags_as_map = {
    Testing   = "IAC"
    Terraform = "AWSTF"
  }
}