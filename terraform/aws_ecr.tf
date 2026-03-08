# =========================================
# AWS ECR Repository Configuration
# =========================================

# 定義三個微服務名稱
locals {
  microservices = ["frontend", "auth", "api"]
}

# 建立對應的 ECR repository
resource "aws_ecr_repository" "app_repos" {

  # 將 microservices list 轉成 set 逐一建立
  for_each = toset(local.microservices)

  # repository 名稱
  name = "tf-project-${each.key}"

  # 允許 image tag 被覆蓋
  image_tag_mutability = "MUTABLE"

  # push image 時自動進行漏洞掃描
  image_scanning_configuration {
    scan_on_push = true
  }

  # 基本標籤
  tags = {
    Environment = var.environment
    Project     = "tf-project"
  }
}