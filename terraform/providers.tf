terraform {
  # 宣告雲端供應商、版本
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0" 
    }
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }  
}

# -----------------------------------------------------------
# AWS設定
# -----------------------------------------------------------
provider "aws" {
  # AWS資源建立地點
  region = "ap-east-2" 
}

# -----------------------------------------------------------
# GCP設定
# -----------------------------------------------------------
provider "google" {
  # GCP專案名、資源建立地點
  project = var.gcp_project_id  
  region  = "asia-east1" 
}