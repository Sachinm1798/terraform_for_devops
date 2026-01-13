variable "env" {
  description = "This is the environment for my infrastructure"
  type = string
}

variable "bucket_name" {
  description = "This is the bucket_name for my infrastructure"
  type = string
}

variable "instance_count" {
  description = "This is the number of instances for my infrastructure"
  type = string
}

variable "instance_type" {
  description = "This is the instance type for my infrastructure"
  type = string
}

variable "ec2_ami_id" {
  description = "This is the AMI ID for my infrastructure"
  type = string
}

variable "hash_key" {
  description = "This is the hash key for my dynamodb infrastructure"
  type = string
}
