resource "google_compute_instance" "default" {
  name         = "dev-${random_id.random.hex}"
  machine_type = "n1-standard-1"
  zone         = "australia-southeast1-a"

  allow_stopping_for_update = false

  tags = ["${var.app}"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  scratch_disk {
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata = {
    foo = "bar"
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
