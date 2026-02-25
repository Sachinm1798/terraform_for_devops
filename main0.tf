
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version ~> "6.27.0"
    }
  }
}            #Terraform Block creates a .terraform.lock.hcl to include in your version control

provider "aws" {
  region = "ap-south-1"
}            #Provider Block

resource "aws_ec2" "MyEc2-1" {
    #configuration/Attributes
}

resource "aws_s3_bucket" "s3_bucket1" {
  bucket = "my-s3-bucket1998"

  tags = {
    Name        = "nubinix"
    Environment = "prod"
  }
}
