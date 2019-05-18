data "google_folder" "project" {
  folder = "folders/${var.project_folder}"
}

resource "random_id" "random" {
  prefix      = "${var.app}-"
  byte_length = "5"
}

resource "google_project" "app" {
  name       = "${random_id.random.hex}"
  project_id = "${random_id.random.hex}"
  folder_id  = "${data.google_folder.project.id}"

  billing_account = "${var.billing_account}"

  auto_create_network = false
}

resource "google_project_service" "project" {
  count   = "${length(var.project_services)}"
  project = "${google_project.app.project_id}"
  service = "${element(var.project_services, count.index)}"
  disable_on_destroy = false
}

resource "google_service_account" "app" {
  account_id   = "${var.app}"
  display_name = "${var.app}"
  project      = "${google_project.app.project_id}"

  depends_on = ["google_project_service.project"]
}

resource "google_service_account_key" "app" {
  service_account_id = "${google_service_account.app.name}"
}

resource "google_project_iam_member" "service-account" {
  count   = "${length(var.service_account_iam_roles)}"
  project = "${google_project.app.project_id}"
  role    = "${element(var.service_account_iam_roles, count.index)}"
  member  = "serviceAccount:${google_service_account.app.email}"
}

output "project_id" {
  value = "${google_project.app.id}"
}

output "project_service_account_key" {
  value = "${google_service_account_key.app.private_key}"
}
