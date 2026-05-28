
resource "google_compute_region_instance_template" "week_10" {
  name         = "week-10"
  #name_prefix  = "web-template"
  region        = "us-central1"
  machine_type = "e2-medium"

  tags = ["web-server"]

  disk {
    source_image = "debian-cloud/debian-11"
    auto_delete  = true
    disk_size_gb = 100
    boot         = true
  }

  network_interface {
    subnetwork = google_compute_subnetwork.week_10.id

    access_config {
      #Ephemeral public IP
    }
  }

  metadata_startup_script = file("./stratup.sh.")
}