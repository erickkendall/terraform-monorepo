terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

module "networking" {
  source = "../../modules/networking"

  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  environment        = var.environment
}

module "compute" {
  source = "../../modules/compute"

  instance_type      = var.instance_type
  ami_id             = var.ami_id
  subnet_id          = module.networking.public_subnet_id
  environment        = var.environment
}
