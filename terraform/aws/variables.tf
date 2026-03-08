# AWS Region
variable "aws_region" {
  description = "The Region of AWS"
  type        = string
}

# 部署環境變數
variable "environment" {
  description = "目前的部署環境 (例如: dev, staging, prod)"
  type        = string
  default     = "dev"
}

# =========================================
# GitHub 整合變數
# =========================================
variable "repo_name" {
  description = "GitHub 專案名稱 (帳號/專案名)"
  type        = string
}

variable "repo_branch" {
  description = "監聽分支名稱"
  type        = string
  default     = "main"
}