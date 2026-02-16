

data "aws_subnets" "all" {
  filter {
    name   = "vpc-id"
    values = [var.vpc_id]
  }
}

data "aws_subnet" "all" {
  for_each = toset(data.aws_subnets.all.ids)
  id       = each.value
}


#User Data

locals {
  user_data = <<EOF
<powershell>
Set-ExecutionPolicy unrestricted -Force
Rename-Computer -F ${var.useradname}-Dev -restart
#Pass Domain Creds
$username = "corp.ahpegasus.com\SVC_ldapbind"
$password = "${var.admin_password}" | ConvertTo-SecureString -AsPlainText -Force
$cred = New-Object -typename System.Management.Automation.PSCredential($username, $password)

#Adding to domain
Try {
Add-Computer -DomainName corp.ahpegasus.com -Credential $cred -Force -Restart -erroraction 'stop'
}

#Get Error messages in a file
Catch{
echo $_.Exception | Out-File c:\error-joindomain.txt -Append
}
net localgroup administrators corp\${var.useradname} /add
</powershell>
EOF
}

# Security Group

module "security_group" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "~> 3.0"

  name        = "Security group ${var.hostname}"
  description = "Security group for usage with EC2 instance"
  vpc_id      = var.vpc_id

  ingress_cidr_blocks = ["10.0.0.0/8"]
  ingress_rules       = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.0.0.0/8"
    },
    {
      rule        = "ssh-tcp"
      cidr_blocks = "10.0.0.0/8"
    },
    {
      rule        = "rdp-tcp"
      cidr_blocks = "10.0.0.0/8"
    },
    {
      rule        = "http-80-tcp"
      cidr_blocks = "10.0.0.0/8"
    },
  ]
  # Default CIDR blocks, which will be used for all egress rules in this module. Typically these are CIDR blocks of the VPC.
  # If this is not specified then no CIDR blocks will be used.
  egress_cidr_blocks = ["0.0.0.0/0"]

  egress_ipv6_cidr_blocks = ["::/0"]

  # Prefix list ids to use in all egress rules in this module.
  # egress_prefix_list_ids = ["pl-123456"]
  # Open for all CIDRs defined in egress_cidr_blocks
  egress_with_cidr_blocks = [
    {
      from_port   = 0
      to_port     = 0
      protocol    = "all"
      description = "Allowing traffic out"
      cidr_blocks = "0.0.0.0/0"
    }
  ]
  tags = {
    Role            = var.role
    XMCC            = var.xmcc
    APPNAME         = var.appname
    DeploymentState = var.dpstate

  }
}


# instances
resource "aws_instance" "ec2Instances" {
  count                       = 1
  ami                         = var.inst_ami
  availability_zone           = lookup(var.availability_zone, var.vpc_region)
  instance_type               = var.inst_type
  key_name                    = var.aws_key_name
  subnet_id                   = var.subnetid
  associate_public_ip_address = false
  source_dest_check           = false

  vpc_security_group_ids = [module.security_group.this_security_group_id]

  user_data_base64 = base64encode(local.user_data)


  root_block_device {
    volume_size           = "100"
    volume_type           = "gp2"
    delete_on_termination = "true"
  }


  ebs_block_device {
    device_name = "/dev/xvdb"
    volume_type = "gp2"
    volume_size = 150
    encrypted   = true
  }

  tags = {
    Name            = var.hostname
    Role            = var.role
    XMCC            = var.xmcc
    APPNAME         = var.appname
    DeploymentState = var.dpstate

  }
}

output "ec2_ip_address" {
  value = aws_instance.ec2Instances.0.private_ip
}
