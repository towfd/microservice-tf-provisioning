resource "google_container_cluster" "primary" {
  name     = "tf-gke-cluster"
  location = var.gcp_region
  # 啟用 Autopilot 模式
  enable_autopilot    = true
  deletion_protection = false
}