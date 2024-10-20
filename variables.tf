variable "region" {
  description = "The region in which the resources will be deployed"
  type        = string
  default     = "us-east-1"
}

variable "environment" {
  description = "The environment in which the resources will be deployed"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "The name of the project"
  type        = string
  default     = "my-project"

}

variable "instance_type" {
  description = "The instance type to be used for the EC2 instance"
  type        = string
  default     = "t2.micro"

}

variable "public_key" {
  description = "The path to the public key to be used for SSH access"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "vpc_cidr_block" {
  description = "The CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "private_subnet_cidr_blocks" {
  description = "Available cidr blocks for private subnets."
  type        = list(string)
  default = [
    "10.0.101.0/24",
    "10.0.102.0/24",
    "10.0.103.0/24",
    "10.0.104.0/24",
    "10.0.105.0/24",
    "10.0.106.0/24",
    "10.0.107.0/24",
    "10.0.108.0/24",
    "10.0.109.0/24",
    "10.0.110.0/24",
    "10.0.111.0/24",
    "10.0.112.0/24",
    "10.0.113.0/24",
    "10.0.114.0/24",
    "10.0.115.0/24",
    "10.0.116.0/24"
  ]
}

variable "public_subnet_cidr_blocks" {
  description = "Available cidr blocks for public subnets."
  type        = list(string)
  default = [
    "10.0.1.0/24",
    "10.0.2.0/24",
    "10.0.3.0/24",
    "10.0.4.0/24",
    "10.0.5.0/24",
    "10.0.6.0/24",
    "10.0.7.0/24",
    "10.0.8.0/24",
    "10.0.9.0/24",
    "10.0.10.0/24",
    "10.0.11.0/24",
    "10.0.12.0/24",
    "10.0.13.0/24",
    "10.0.14.0/24",
    "10.0.15.0/24",
    "10.0.16.0/24"
  ]
}

variable "instances_per_subnet" {
  description = "Number of EC2 instances in each private subnet"
  type        = number
  default     = 2
}
