#Dev infrastructure

module "dev-infra" {
       source = "./infra-app"
       env = "dev"
       bucket_name = "infra-app-bucket"
       instance_count = 1
       instance_type = "t3.micro"
       ec2_ami_id = "ami-02b8269d5e85954ef"
       hash_key = "studentID"
}

#staging infrastructure

module "stag-infra" {
       source = "./infra-app"
       env = "dev"
       bucket_name = "infra-app-bucket"
       instance_count = 1
       instance_type = "t3.micro"
       ec2_ami_id = "ami-02b8269d5e85954ef"
       hash_key = "studentID"
}

#Production infrastructre

module "prod-infra" {
       source = "./infra-app"
       env = "dev"
       bucket_name = "infra-app-bucket"
       instance_count = 2
       instance_type = "t3.micro"
       ec2_ami_id = "ami-02b8269d5e85954ef"
       hash_key = "studentID"
}

