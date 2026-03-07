# =================================================================
# AWS 資源設定區塊(ECR 儲存庫)
# =================================================================

# 微服務清單
locals {
  microservices = ["frontend", "auth", "api"]
}
# 建立三個 ECR 儲存庫
resource "aws_ecr_repository" "app_repos" {
  # 清單轉集合，讓Terraform跑
  for_each = toset(local.microservices)
  # 儲存庫名稱
  name = "tf-project-${each.key}" 
  
  # 允許覆寫相同的tag
  image_tag_mutability = "MUTABLE"

  # 自動資安掃描
  image_scanning_configuration {
    scan_on_push = true
  }

  tags = {
    Environment = var.environment
    Project     = "tf-project"
  }
}