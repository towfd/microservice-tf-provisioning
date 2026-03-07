# GCP 專案 ID 的變數
variable "gcp_project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
}

# 部署環境變數
variable "environment" {
  description = "目前的部署環境 (例如: dev, staging, prod)"
  type        = string
  default     = "dev"
}