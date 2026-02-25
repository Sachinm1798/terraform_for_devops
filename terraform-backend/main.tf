terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.27.0"
    }
  }
  provider "aws" {
  region = "ap-south-1"
}
#This backend need to be configured separatly with already created s3 and dynamodb manually
#The use the name of those in our current infrastructure setup
#Earlier we used a dynamodb now an s3 can handles this internally using use_lockfile
#use separate folders like dev/test/prod
 
backend "s3" {
  bucket = "tfstatefile-bucket1998"
  key = "dev/terraform.tfstate"
  region = "ap-south-1"
  encrypt = true
  use_lockfile = true
  #inbuilt locking mechanism without dynamodb
  dynamodb_table = "terraform-dynamodb"
 }

} 
