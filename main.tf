terraform {
  backend "s3" {
    bucket = "nurple"
    key    = "terraform/terraform.tfstate"
    region = "us-east-1"
  }
}
