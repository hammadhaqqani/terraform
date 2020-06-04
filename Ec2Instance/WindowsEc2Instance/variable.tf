variable "availability_zone" {
  description = "availability zone used for the demo, based on AWS region"
  default = {
    us-west-2 = "us-west-2c"
  }
}

# this is a keyName for key pairs
variable "aws_key_name" {
  description = "Key Pair Name used to provision to the box"
  default = "us-west-2-provisioner"
}

variable "inst_ami" {
  description = "Amazon Machine Image for the Instance"
  default = "ami-059377ba193aa9309"
}

variable "inst_type" {
  description = "type of instances to provision"
  default = "t2.xlarge"
}

variable "vpc_public_sg_id" {
  description = "VPC public security group"
  default = ""
}

variable "vpc_id" {
  description = "VPC public subnet"
  default = "vpc-d1bb2db4"
}

variable "vpc_region" {
  description = "VPC region"
   default = "us-west-2"
}


variable "hostname" {
  description = "Host name of EC2 Machine"
  default = "Dev-Test-Instance"
}

variable "role" {
  description = "Role of the EC2 Machine"
  default = "Webserver"
}

variable "xmcc" {
  description = "Cost Center"
  default = "9243"
}

variable "appname" {
  description = "Application Name"
  default = "ITOPS"
}

variable "dpstate" {
  description = "DeploymentState"
  default = "Dev"
}



variable "admin_password" {
  description = "AD Admin Password"
}

variable "subnetid" {
  description = "Provide Instance Subnet"
  default = "subnet-e3f851ba"
}


variable "useradname" {
  description = "User Corp ID"
  default = "hhaqqani"
}