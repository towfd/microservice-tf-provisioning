# =========================================
# AWS CI/CD Pipeline as Code
# =========================================

# 建立與 GitHub 的連線
resource "aws_codestarconnections_connection" "github" {
  name          = "tf-github-connection"
  provider_type = "GitHub"
}

# 建立 Pipeline 專用的 S3 暫存桶
resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket_prefix = "tf-pipeline-artifacts-"
  force_destroy = true
}

# 建立 CodeBuild 機器人
resource "aws_codebuild_project" "tf_build" {
  name         = "tf-aws-build-project-iac"
  description  = "由 Terraform 自動建立的施工機器人"
  service_role = aws_iam_role.codebuild_role.arn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:7.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"

    # 變數
    environment_variable {
      name  = "TF_VAR_aws_region"
      value = var.aws_region
    }
    
    environment_variable {
      name  = "TF_VAR_repo_name"
      value = var.repo_name
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "terraform/aws/buildspec.yml"
  }
}

# CodePipeline Stack
resource "aws_codepipeline" "tf_pipeline" {
  name     = "tf-aws-infrastructure-pipeline-iac"
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"
  }

  # 監聽 GitHub
  stage {
    name = "Source"
    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]
      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.github.arn
        FullRepositoryId = var.repo_name
        BranchName       = var.repo_branch
      }
    }
  }

  # 觸發 CodeBuild
  stage {
    name = "Build"
    action {
      name            = "Build"
      category        = "Build"
      owner           = "AWS"
      provider        = "CodeBuild"
      input_artifacts = ["source_output"]
      version         = "1"
      configuration = {
        ProjectName = aws_codebuild_project.tf_build.name
      }
    }
  }
}

# =========================================
# IAM 權限區塊
# =========================================

# 給 CodeBuild (AdministratorAccess)
resource "aws_iam_role" "codebuild_role" {
  name = "tf-codebuild-iac-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "codebuild.amazonaws.com" }
    }]
  })
}
resource "aws_iam_role_policy_attachment" "codebuild_admin" {
  role       = aws_iam_role.codebuild_role.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# CodePipeline權限
resource "aws_iam_role" "codepipeline_role" {
  name = "tf-codepipeline-iac-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action    = "sts:AssumeRole"
      Effect    = "Allow"
      Principal = { Service = "codepipeline.amazonaws.com" }
    }]
  })
}
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "tf-codepipeline-iac-policy"
  role = aws_iam_role.codepipeline_role.id
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect   = "Allow"
        Action   = ["s3:*", "codebuild:*", "codestar-connections:UseConnection", "iam:PassRole"]
        Resource = "*"
      }
    ]
  })
}