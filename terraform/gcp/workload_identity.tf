# =========================================
# GCP Service Account & Workload Identity
# =========================================

# 建立 GCP 專屬的服務帳號 (GSA)
resource "google_service_account" "gke_aws_sa" {
  account_id   = "gke-aws-ecr-puller"
  display_name = "GKE Service Account for AWS ECR Pull"
}

# 設定 Workload Identity 綁定
# 允許 K8s 裡面名為 "aws-ecr-sa" 的帳號，合法扮演上面這個 GCP 帳號
resource "google_service_account_iam_binding" "workload_identity_binding" {
  service_account_id = google_service_account.gke_aws_sa.name
  role               = "roles/iam.workloadIdentityUser"

  members = [
    "serviceAccount:${var.gcp_project_id}.svc.id.goog[default/aws-ecr-sa]"
  ]
}

output "gcp_service_account_unique_id" {
  value       = google_service_account.gke_aws_sa.unique_id
  description = "GCP 服務帳號的唯一識別碼 (要填入 AWS OIDC Condition)"
}

output "gcp_service_account_email" {
  value       = google_service_account.gke_aws_sa.email
  description = "GCP 服務帳號的 Email (等一下 K8s 部署會用到)"
}

# 賦予 GKE Vertex AI 的呼叫權限
resource "google_project_iam_member" "gke_aws_sa_vertex_ai" {
  project = var.gcp_project_id
  role    = "roles/aiplatform.user"
  member  = "serviceAccount:${google_service_account.gke_aws_sa.email}"
}