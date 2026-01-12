resource "aws_s3_bucket" "s3_bucket1" {
  bucket = "my-s3-bucket1998"

  tags = {
    Name        = "nubinix"
    Environment = "prod"
  }
}
