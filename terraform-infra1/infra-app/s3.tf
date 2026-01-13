
resource "aws_s3_bucket" "s3_bucket1" {
  bucket = "${var.env}-${var.bucket_name}"

  tags = {
    Name        = "nubinix"
    Environment = var.env
  }
}

