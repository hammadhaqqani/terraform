variable "availability_zone" {
  description = "availability zone used for the demo, based on AWS region"
  default = {
    us-west-2 = "us-west-2c"
  }
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


variable "bucketname" {
  description = "S3 Bucket Name"  
}
