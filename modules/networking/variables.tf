variable "instance_type" {
  description = "The EC2 instance type"
  type        = string
}

variable "ami_id" {
  description = "The AMI ID for the EC2 instance"
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet to deploy the instance in"
  type        = string
}

variable "environment" {
  description = "The deployment environment"
  type        = string
}
