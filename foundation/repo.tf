resource "google_sourcerepo_repository" "app" {
  name    = "${var.app}"
  project = "${google_project.app.project_id}"

  depends_on = ["google_project_service.project"]
}

resource "google_cloudbuild_trigger" "app" {
  description = "[${var.app}] Run foundations terraform"
  project     = "${google_project.app.project_id}"

  trigger_template {
    branch_name = "dev"
    repo_name   = "${google_sourcerepo_repository.app.name}"
  }

  filename = "foundation/cloudbuild.yaml"
  included_files = ["foundation/**/*"]

  substitutions = {
    _FOUNDATIONS_PREFIX = "${var.foundations_prefix}"
    _TF_DOMAIN = "${var.domain}"
    _SECRETS_KEYRING = "${google_kms_key_ring.workstation-keyring.name}"
    _SECRETS_KEY = "${google_kms_crypto_key.workstation.name}"
  }
}

resource "null_resource" "push-current-repo-to-gcr" {
  provisioner "local-exec" {
    command = <<EOF
git config credential.helper gcloud
git push -f gcp dev
EOF
  }

  depends_on = ["google_cloudbuild_trigger.app"]
}

output "sourcerepo_url" {
  value = "${google_sourcerepo_repository.app.url}"
}
