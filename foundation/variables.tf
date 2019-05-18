variable "domain" {}

variable "billing_account" {}

variable "foundations_prefix" {}

variable "project_folder" {}

variable "app" {}

variable "region" {
  type    = "string"
  default = "australia-southeast1"
}

variable "location" {
  type    = "string"
  default = "australia-southeast1-a"
}

variable "project_services" {
  type = "list"

  default = [
    "cloudbuild.googleapis.com",
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "container.googleapis.com",
    "containerregistry.googleapis.com",
    "iam.googleapis.com",
    "sourcerepo.googleapis.com",
  ]
}

variable "service_account_iam_roles" {
  type = "list"

  default = [
    "roles/monitoring.viewer",
    "roles/monitoring.metricWriter",
    "roles/logging.logWriter",
    "roles/storage.objectViewer",
  ]
}

variable "gke_max_pods_per_node" {
  description = "Kubernetes default is 110 pods per node"
  default     = 110
}

variable "my_ip" {}
