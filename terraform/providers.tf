terraform {
  # 宣告需要用的雲端供應商、版本
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" # 使用 5.x 版本的 AWS 模組
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0" # 使用 5.x 版本的 GCP 模組
    }
  }  
}

# -----------------------------------------------------------
# AWS設定
# -----------------------------------------------------------
provider "aws" {
  # AWS資源建立地點
  region = "ap-east2" 
}

# -----------------------------------------------------------
# GCP設定
# -----------------------------------------------------------
provider "google" {
  # GCP專案名、資源建立地點
  project = var.gcp_project_id  
  region  = "asia-east1" 
}