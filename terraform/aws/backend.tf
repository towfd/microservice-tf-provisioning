terraform {
  backend "s3" {
    bucket = "fd-terraform-project-s3-backend-store"
    key    = "terraform/aws/terraform.tfstate"
    region = "ap-east-2"
  }
}