resource "aws_s3_bucket" "S3Bucket" {
  bucket = var.bucketname
  acl = "private"
  versioning {
    enabled = true
  }
  tags = {
    Name = var.bucketname
    Role = var.role
    XMCC = var.xmcc
    APPNAME = var.appname
    DeploymentState = var.dpstate
  }
  region = "us-west-2"
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
 }

}