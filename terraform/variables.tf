# GCP 專案 ID 的變數
variable "gcp_project_id" {
  description = "The ID of the Google Cloud project"
  type        = string
}

#s3 bucket名稱
variable "s3_bucket_name" {
    description = "Name of the s3 bucket"
    type = string
}