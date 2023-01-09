#
#  templatefile
#  https://developer.hashicorp.com/terraform/language/functions/templatefile
# 
#  To avoid Terraform trying to interpret pipeline vars in the template file escape them with an
#  additional dollar sign -> e.g. `$${{ secrets.GOOGLE_CHAT_WEBHOOK }}`
#

resource "github_repository_file" "docker_pipeline_security_scans" {
  repository          = var.repo_name
  branch              = "main"
  commit_message      = "[Actions Bot] Update Github Actions workflow"
  overwrite_on_create = true
  file                = ".github/workflows/security-scans.yml"
  content = templatefile("${path.module}/assets/workflows/websitesecurity-scans-tftpl.yml", {
    image = "${var.image_name}:${var.image_tag}",
    args  = "--file=${var.dockerfile}"
  })
}
