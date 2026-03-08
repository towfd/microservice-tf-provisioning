terraform {
  backend "gcs" {
    bucket = "fd-terraform-project-gcp-backend"
    prefix = "terraform/gcp/state"
  }
}
