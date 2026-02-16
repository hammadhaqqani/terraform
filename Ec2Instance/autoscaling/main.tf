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
      "amzn2-ami-hvm-*-x86_64-gp2",
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

  provisioner "local-exec" {
    command = "sleep 10"
  }
}

######
# Launch template and autoscaling group
######
module "example" {
  source  = "terraform-aws-modules/autoscaling/aws"
  version = "~> 8.0"

  name = "webserver-asg"

  # Launch template
  launch_template_name        = "Linux-lt"
  launch_template_description = "Launch template for webserver ASG"
  image_id                    = data.aws_ami.amazon_linux.id
  instance_type               = "t2.micro"

  network_interfaces = [
    {
      associate_public_ip_address = true
      security_groups             = [data.aws_security_group.default.id]
      delete_on_termination       = true
    }
  ]

  block_device_mappings = [
    {
      device_name = "/dev/xvdz"
      ebs = {
        volume_type           = "gp3"
        volume_size           = 50
        delete_on_termination = true
      }
    }
  ]

  # Auto scaling group
  vpc_zone_identifier       = data.aws_subnets.all.ids
  health_check_type         = "EC2"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 0
  wait_for_capacity_timeout = 0
  service_linked_role_arn   = aws_iam_service_linked_role.autoscaling.arn

  tags = {
    Name            = var.hostname
    Role            = var.role
    XMCC            = var.xmcc
    APPNAME         = var.appname
    DeploymentState = var.dpstate
    Project         = "IAC"
    Testing         = "IAC"
    Terraform       = "AWSTF"
  }
}
