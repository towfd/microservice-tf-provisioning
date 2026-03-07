# =================================================================
# GCP 資源設定(VPC 虛擬網路與子網段)
# =================================================================

# 建立VPC
resource "google_compute_network" "vpc_network" {
  name                    = "tf-project-vpc-${var.environment}"
  # 關閉自動建立子網段
  auto_create_subnetworks = false 
}

# 建立 GKE 專用的子網段
resource "google_compute_subnetwork" "gke_subnet" {
  name          = "tf-project-gke-subnet-${var.environment}"
  region        = var.gcp_region
  network       = google_compute_network.vpc_network.id
  # 給 K8s 節點用
  ip_cidr_range = "10.10.0.0/16" 
}