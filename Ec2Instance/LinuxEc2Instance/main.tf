

data "aws_subnet_ids" "all" {
  vpc_id = var.vpc_id
}

data "aws_subnet" "all" {
  for_each = data.aws_subnet_ids.all.ids
  id       = each.value
}



#User Data

locals {
  user_data = <<EOF
#!/bin/bash
set -x
#Variable
DNSNAME="search     corp.ahpegasus.com"
DNSIP="nameserver 10.60.0.10"
# Repository Updates 
apt update -y
# Installing Required Package
export DEBIAN_FRONTEND=noninteractive
apt-get install sssd -y
apt-get install realmd -y
apt-get install oddjob -y
apt-get install oddjob-mkhomedir -y
apt-get install adcli -y
apt-get install samba-common -y
apt-get install samba-common-bin -y
apt-get install krb5-user -y
apt-get install ldap-utils -y
apt-get install libpam-ldap -y
apt-get install libnss-ldap -y
apt-get install policycoreutils -y
apt-get install sssd-tools -y
apt-get install sssd -y
apt-get install libnss-sss -y
apt-get install libpam-sss -y         
# DNS ENTRY
if grep -Fxq "$DNSNAME" /etc/resolv.conf
then
    echo "DNSNAME ENTRY EXIST"
else
    echo "$DNSNAME" >> /etc/resolv.conf
fi
if grep -Fxq "$DNSIP" /etc/resolv.conf
then
    echo "DNSIP ENTRY EXIST"
else
    echo "$DNSIP" >> /etc/resolv.conf
fi
# Setting Hostname
hostnamectl set-hostname ${var.hostname}
# Joining Machine TO Domain
echo "${var.admin_password}" | realm join --user=SVC_ldapbind corp.ahpegasus.com --install=/
# Home Directory in SSSD Config
echo "create_homedir = true" >> /etc/sssd/sssd.conf
# Pam.d Entry For HomeDirectory
echo "session required pam_mkhomedir.so umask=0022 skel=/etc/skel" >> /etc/pam.d/common-session
# Restart SSSD Service
service sssd restart
# Providing Permission For Linux Admin Groups
realm permit -g "LinuxAdmins"@corp.ahpegasus.com
# Enabling SSH Password Authentication Config
sed -i "/^[^#]*PasswordAuthentication[[:space:]]no/c\PasswordAuthentication yes" /etc/ssh/sshd_config
# Restart SSHD Serice
service sshd restart
# Adding ITops User
useradd -m -p $password/fw itops
# Adding Sudo Permission  To User
usermod -aG sudo itops
# END OF Script  
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
    device_name = "/dev/sda1"
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
