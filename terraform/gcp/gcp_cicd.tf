resource "google_cloudbuild_trigger" "gcp_pipeline" {
  name        = "tf-gcp-infrastructure-pipeline"
  description = "監聽 terraform/gcp 異動的pipeline"

  github {
    owner = split("/", var.repo_name)[0]
    name  = split("/", var.repo_name)[1]
    push {
      branch = "^main$"
    }
  }

  # 只有改動 terraform/gcp 底下的檔案才會觸發
  included_files = ["terraform/gcp/**"]

  # 指定手冊位置
  filename = "terraform/gcp/cloudbuild.yaml"
}