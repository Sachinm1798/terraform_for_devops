terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }
#This backend need to be configured separatly with s3 and dynamodb only 
#The use the name of those in our current infrastructure setup
 
backend "s3" {

  bucket = "my-s3-bucket1998"
  key = "terraform.tfstate"
  region = "ap-south-1"
  dynamodb_table = "terraform-dynamodb"
 }

} 
