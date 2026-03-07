terraform {
  backend "s3" {
    # S3 Bucket名稱
    bucket = var.s3_bucket_name
    
    # 日誌檔檔名與路徑
    key    = "terraform/state/terraform.tfstate"    
    region = "ap-east2"
  }
}