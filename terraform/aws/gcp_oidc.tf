# =========================================
# GCP OIDC Provider & IAM Role for GKE
# =========================================

# 建立 Google OIDC 身份
resource "aws_iam_openid_connect_provider" "google" {
  url = "https://accounts.google.com"
  client_id_list = [
    "sts.amazonaws.com",
    "115176010041409675273"
  ]
  # Google 官方的憑證指紋
  thumbprint_list = ["08745487e891c19e3078c1f2a07e452950ef36f6", "ffffffffffffffffffffffffffffffffffffffff"]
}

# 2. 建立 GKE 的 IAM 角色
resource "aws_iam_role" "gke_ecr_pull_role" {
  name = "gke-ecr-pull-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.google.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "accounts.google.com:aud" : [
              "sts.amazonaws.com",
              "115176010041409675273"
            ]
          }
          StringLike = {
            # 用來限制只有哪個 GCP 可以拿通行證
            "accounts.google.com:sub" : "115176010041409675273"
          }
        }
      }
    ]
  })
}

# 給這個角色賦予只能下載 ECR Image 的權限 (最小權限原則)
resource "aws_iam_role_policy" "gke_ecr_pull_policy" {
  name = "gke-ecr-pull-policy"
  role = aws_iam_role.gke_ecr_pull_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # 允許登入並拉取 (Pull) Image，不允許上傳 (Push)
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage"
        ]
        Resource = "*"
      }
    ]
  })
}

# 輸出這個 Role 的 ARN
output "gke_ecr_pull_role_arn" {
  value       = aws_iam_role.gke_ecr_pull_role.arn
  description = "給 GCP GKE 使用的 IAM Role ARN"
}