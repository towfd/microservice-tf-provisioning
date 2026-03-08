terraform {
  backend "s3" {
    bucket = "fd-terraform-project-s3-backend"
    key    = "terraform/aws/terraform.tfstate"
    region = "ap-northeast-1"
  }
}