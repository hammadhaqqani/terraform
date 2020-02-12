provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}

locals {
  user_data = <<EOF
#!/bin/bash
echo "Hello Terraform!"
EOF
}

resource "aws_instance" "hammadinstance" {
  ami           = "ami-b374d5a5"
  instance_type = "t2.micro"
   tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

resource "aws_eip" "ip" {
    vpc = true
    instance = aws_instance.hammadinstance.id
}

