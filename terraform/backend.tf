# wordpress-infrastructure/terraform/backend.tf

terraform {
  backend "s3" {
    bucket = "wordpress-poc-dext-tf-files"
    key    = "terraform.tfstate"
    region = "us-east-2"
  }
}
