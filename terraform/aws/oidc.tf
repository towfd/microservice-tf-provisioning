# =========================================
# GitHub OIDC Provider & IAM Role
# =========================================

# 建立 GitHub OIDC 身份提供者
resource "aws_iam_openid_connect_provider" "github" {
  url            = "https://token.actions.githubusercontent.com"
  client_id_list = ["sts.amazonaws.com"]
  # GitHub 官方憑證指紋
  thumbprint_list = ["1b511abead59c6ce207077c0bf0e0043b1382612", "ffffffffffffffffffffffffffffffffffffffff"]
}

# 建立給 GitHub Actions 用的 IAM 角色
resource "aws_iam_role" "github_actions_role" {
  name = "github-actions-ecr-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Federated = aws_iam_openid_connect_provider.github.arn
        }
        Action = "sts:AssumeRoleWithWebIdentity"
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" : "sts.amazonaws.com"
          }
          StringLike = {
            # 限制Repo 可以拿通行證
            "token.actions.githubusercontent.com:sub" : "repo:towfd/microservice-tf-provisioning:*"
          }
        }
      }
    ]
  })
}

# 給這個角色賦予操作 ECR 的權限
resource "aws_iam_role_policy" "github_actions_ecr_policy" {
  name = "github-actions-ecr-policy"
  role = aws_iam_role.github_actions_role.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # 允許登入 ECR
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken"
        ]
        Resource = "*"
      },
      {
        # 允許上傳和下載 Docker Image
        Effect = "Allow"
        Action = [
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:GetRepositoryPolicy",
          "ecr:DescribeRepositories",
          "ecr:ListImages",
          "ecr:DescribeImages",
          "ecr:BatchGetImage",
          "ecr:InitiateLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:CompleteLayerUpload",
          "ecr:PutImage"
        ]
        Resource = "*"
      }
    ]
  })
}

# 輸出這個 Role 的 ARN
output "github_actions_role_arn" {
  value       = aws_iam_role.github_actions_role.arn
  description = "給 GitHub Actions 使用的 IAM Role ARN"
}