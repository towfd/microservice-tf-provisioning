# 建立服務帳號
resource "google_service_account" "cloudbuild_sa" {
  project      = var.gcp_project_id
  account_id   = "tf-cloudbuild-sa"
  display_name = "Terraform Cloud Build Service Account"
}

# 賦予服務帳號編輯者權限
resource "google_project_iam_member" "cloudbuild_sa_editor" {
  project = var.gcp_project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.cloudbuild_sa.email}"
}

# 綁定 GitHub
resource "google_cloudbuildv2_repository" "github_repo_link" {
  project           = var.gcp_project_id
  name              = split("/", var.repo_name)[1]
  location          = var.gcp_region
  parent_connection = "projects/${var.gcp_project_id}/locations/${var.gcp_region}/connections/towfd"
  remote_uri        = "https://github.com/${var.repo_name}.git"
}

# 建立 Trigger，並掛上服務帳號
resource "google_cloudbuild_trigger" "gcp_pipeline" {
  project     = var.gcp_project_id
  name        = "tf-gcp-infrastructure-pipeline"
  description = "監聽 terraform/gcp 異動的pipeline"
  location    = var.gcp_region

  service_account = google_service_account.cloudbuild_sa.id

  repository_event_config {
    repository = google_cloudbuildv2_repository.github_repo_link.id

    push {
      branch = "^main$"
    }
  }

  filename = "terraform/gcp/cloudbuild.yaml"
}