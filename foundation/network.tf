resource "google_compute_network" "vpc" {
  name                    = "${random_id.random.hex}-vpc"
  project                 = "${google_project.app.project_id}"
  routing_mode            = "GLOBAL"
  auto_create_subnetworks = false

  depends_on = ["google_project_service.project"]
}

resource "google_compute_subnetwork" "app" {
  name          = "${random_id.random.hex}-subnet"
  project       = "${google_project.app.project_id}"
  ip_cidr_range = "10.0.0.0/24"
  network       = "${google_compute_network.vpc.self_link}"

  # access PaaS without external IP
  private_ip_google_access = true

  secondary_ip_range {
    range_name    = "pods"
    ip_cidr_range = "10.110.0.0/20"
  }

  secondary_ip_range {
    range_name    = "services"
    ip_cidr_range = "10.110.16.0/22"
  }
}

/*resource "google_compute_router" "nat" {
  name    = "${random_id.random.hex}-router"
  project = "${google_project.app.project_id}"
  network = "${google_compute_network.vpc.self_link}"
  region  = "${var.region}"
}

resource "google_compute_router_nat" "nat" {
  name                               = "${var.app}-nat"
  project                            = "${google_project.app.project_id}"
  router                             = "${google_compute_router.nat.name}"
  region                             = "${var.region}"
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"

  subnetwork {
    name = "${google_compute_subnetwork.app.self_link}"

    source_ip_ranges_to_nat = [
      "ALL_IP_RANGES"
    ]
  }
}*/

resource "google_compute_firewall" "app-inbound" {
  name    = "${google_project.app.project_id}-app-inbound"
  project = "${google_project.app.project_id}"
  network = "${google_compute_network.vpc.self_link}"

  direction = "INGRESS"
  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = [
    "${var.my_ip}/32"
  ]
}

resource "google_compute_address" "app-external-ip" {
  project = "${google_project.app.project_id}"
  name    = "${var.app}"
}

output "static-external-ip" {
  value = "${google_compute_address.app-external-ip.address}"
}
