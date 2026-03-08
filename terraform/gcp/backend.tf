terraform {
  backend "gcs" {
    bucket  = "你的-gcp-terraform-state-bucket名稱"
    prefix  = "terraform/gcp/state"
  }
}
