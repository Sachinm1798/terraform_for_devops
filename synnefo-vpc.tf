#Terraform Block --> Configuring terraform

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

#Provider Block

provider "aws" {
  region = "ap-south-1" 
}

# Create the S3 bucket

resource "aws_s3_bucket" "my_bucket" {
  bucket = "my-unique-bucket-1998" # Unique bucket name globally
  tags = {
    Name        = "MyVersionedS3Bucket"
    Environment = "Dev"
  }
}

# Enable versioning for the S3 bucket

resource "aws_s3_bucket_versioning" "my_bucket_versioning" {
  bucket = aws_s3_bucket.my_bucket.id
  versioning_configuration {
    status = "Enabled"
  }
}

# Output the bucket ID --> After terraform Apply

output "s3_bucket_id" {
  value = aws_s3_bucket.my_bucket.id
}

#Create a VPC

resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "Mumbai-VPC"
  }
}

# Create a internet gateway associated with vpc

resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags   = {
    Name = "IGW-1"
  }
}

# Create the Route Table with route to internet gateway

resource "aws_route_table" "main_rt" {
  vpc_id = aws_vpc.main_vpc.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main_igw.id
  }
  tags = {
    Name = "Terraform-Public-Route-Table"
  }
}


#Create Three Subnets associated with /Custom Route table/

locals {
  subnets = {
    subnet1 = "10.0.1.0/24"
    subnet2 = "10.0.2.0/24"
    subnet3 = "10.0.3.0/24"
  }
}
# Creating subnets inside single availability zone

resource "aws_subnet" "subnets" {
  for_each = local.subnets
  vpc_id = aws_vpc.main_vpc.id
  cidr_block        = each.value
  availability_zone = "ap-south-1a"
}

resource "aws_route_table_association" "assoc" {
  for_each       = aws_subnet.subnets
  subnet_id      = each.value.id
  route_table_id = aws_route_table.main_rt.id
}

# Create the AWS Key Pair resource in AWS Account
#ssh-keygen -t rsa -b 4096 -f ./my-ec2-key

resource "aws_key_pair" "my_auth_key" {
  key_name   = "my-instance-key"
  public_key = file("${path.module}/my-ec2-key.pub")
}

#Create an secuirty group for ec2 instance

resource "aws_security_group" "web_access" {
  name        = "allow_web_ssh"
  description = "Allow SSH and HTTP inbound traffic"
  vpc_id      =  aws_vpc.main_vpc.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "HTTP-SSH-Security-Group-for-ec2"
  }
}

# Create the EC2 Instance with public_ip with custom key & security group

resource "aws_instance" "web_app" {
  ami           = "ami-0317b0f0a0144b137" 
  instance_type = "t3.micro"
  key_name      = aws_key_pair.my_auth_key.key_name
  subnet_id     = aws_subnet.subnets["subnet2"].id               #Expect a string here
  vpc_security_group_ids = [aws_security_group.web_access.id]    #Expect a list of string here
  associate_public_ip_address = true
  tags = {
    Name = "Terraform-Instance"
  }
}
