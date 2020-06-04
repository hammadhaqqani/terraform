variable "name" {
  description = "Name of the VPC"
  default = "staging-vpc"
}

variable "role" {
  description = "Role of the EC2 Machine"
  default = "VPC"
}

variable "xmcc" {
  description = "Cost Center"
  default = "9240"
}

variable "appname" {
  description = "Application Name"
  default = "ITOPS"
}

variable "dps" {
  description = "DeploymentState"
  default = "Staging"
}

variable "tablename" {
  description = "Dynamodb Table Name"
  default = "TerraformTest"
}