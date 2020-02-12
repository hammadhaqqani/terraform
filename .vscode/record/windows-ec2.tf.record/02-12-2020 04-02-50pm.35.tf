provider "aws" {
  profile    = "default"
  region     = "us-east-1"
}


resource "aws_instance" "Hammad" {
  ami           = "ami-066663db63b3aa675"
  instance_type = "t2.micro"
  key_name = "Ariza2019"
  security_groups = ["${aws_security_group.allow_rdp.name}"]

}

resource "aws_security_group" "allow_rdp" {
  name        = "allow_rdp"
  description = "Allow ssh traffic"


  ingress {

    from_port   = 3389 #  By default, the windows server listens on TCP port 3389 for RDP
    to_port     = 3389
    protocol =   "tcp"

    cidr_blocks =  ["0.0.0.0/0"]
  }
}