terraform {
  backend "gcs" {
    bucket = "fd-terraform-project-gcp-backend-store"
    prefix = "terraform/gcp/state"
  }
}
