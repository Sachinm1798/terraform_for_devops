resource "aws_s3_bucket" "state_bucket" {
  bucket = "tfstatefile-bucket1998"

  tags = {
    Name        = "state-bucket"
    Environment = "dev"
  }
}
