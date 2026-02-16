variable "availability_zone" {
  description = "availability zone used for the demo, based on AWS region"
  default = {
    us-west-2 = "us-west-2c"
  }
}

variable "hostname" {
  description = "Host name of EC2 Machine"
  default     = "Dev-Test-Instance"
}

variable "role" {
  description = "Role of the EC2 Machine"
  default     = "Database"
}

variable "xmcc" {
  description = "Cost Center"
  default     = "9243"
}

variable "appname" {
  description = "Application Name"
  default     = "ITOPS"
}

variable "dpstate" {
  description = "DeploymentState"
  default     = "Dev"
}


variable "rdsname" {
  description = "Name for the RDS Instance"
}

variable "username" {
  description = "Username for RDS Instance"
}

variable "password" {
  description = "Password for RDS Instance"
}


variable "instanceclass" {
  description = "DB Instance Size"
  default     = "db.t2.medium"
}

variable "identifier" {
  description = "Identifier name for instance"
  default     = "terraformtest"
}