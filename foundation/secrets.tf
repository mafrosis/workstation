
# ---------------------------------------------------------------------------------------------------------------------
# KMS Keyring for all encryption / decryption options
#
# NOTE: The following keyring is required to enable us to grab the workstation images from their private registry. These
#       will be redundant when workstation is acting as a docker registry.
# ---------------------------------------------------------------------------------------------------------------------
resource "google_kms_key_ring" "workstation-keyring" {
  name     = "workstation-keyring"
  project  = "${google_project.app.project_id}"
  location = "${var.region}"

  depends_on = ["google_project_service.project"]
}


# ---------------------------------------------------------------------------------------------------------------------
# workstation KMS key
# ---------------------------------------------------------------------------------------------------------------------
resource "google_kms_crypto_key" "workstation" {
  name            = "workstation-key"
  key_ring        = "${google_kms_key_ring.workstation-keyring.self_link}"
  rotation_period = "15552000s"
  # ~ 6 months

  #lifecycle {
  #  prevent_destroy = true
  #}
}

/*resource "google_kms_crypto_key_iam_member" "workstation-encrypt" {
  crypto_key_id = "${google_kms_crypto_key.workstation.self_link}"
  role          = "roles/cloudkms.cryptoKeyEncrypter"
  member        = "group:GCP_EX_Developers@anz.com"
}*/

resource "google_kms_crypto_key_iam_member" "workstation-decrypt" {
  crypto_key_id = "${google_kms_crypto_key.workstation.self_link}"
  role          = "roles/cloudkms.cryptoKeyDecrypter"
  member        = "serviceAccount:${google_project.app.number}@cloudbuild.gserviceaccount.com"
}

output "keyring_name" {
  value = "${google_kms_key_ring.workstation-keyring.name}"
}
output "key_name" {
  value = "${google_kms_crypto_key.workstation.name}"
}
