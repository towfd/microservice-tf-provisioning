terraform {
  backend "s3" {
    # S3 Bucket名稱
    bucket = "fd-terraform-project-s3-backend-store"
    # 日誌檔檔名與路徑
    key    = "terraform/state/terraform.tfstate"    
    region = "ap-east-2"
  }
}