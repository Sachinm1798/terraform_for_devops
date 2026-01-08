#state locking with Dynamodb
#Configure a S3 bucket with Remotedynamodb then you can delete statefile from your local system.
#the configuration is done in terraform file

resource "aws_dynamodb_table" "basic-dynamodb-table" {
  name           = "terraform-dynamodb"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "LockID"

  attribute {
    name = "LockID"
    type = "S"
 }
  tags = {
    Name        = "dynamodb-table-1"
    Environment = "production"
  }
}
