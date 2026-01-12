#Module block to call locally available or an stored modules

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws" #download the modules from internet and then assign these modules
  #version = "5.x.x" # Use the latest version from the registry

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-south-1a", "ap-south-1b"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = false

  tags = {
    Terraform   = "true"
    Environment = "var.env"
  }
}

