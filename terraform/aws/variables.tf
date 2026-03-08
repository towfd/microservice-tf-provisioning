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