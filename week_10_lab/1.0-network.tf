resource "google_compute_network" "week_10" {
  name                    = "week-10"
  routing_mode            = "REGIONAL"
  auto_create_subnetworks = false
}

resource "google_compute_subnetwork" "week_10" {
  name          = "week-10"
  ip_cidr_range = "10.10.0.0/24"
  network       = google_compute_network.week_10.id
  region        = "us-central1"
}

resource "google_compute_firewall" "allow_http_10" {
  name    = "allow-http-10"
  network = google_compute_network.week_10.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["web-server"]
}

# allow SSH
resource "google_compute_firewall" "allow_ssh_10" {
  name    = "allow-ssh-10"
  network = google_compute_network.week_10.name

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }

  source_ranges = ["0.0.0.0/0"]

  target_tags = ["web-server"]
}

resource "google_compute_firewall" "allow_health_check" {
  name    = "allow-health-check"
  network = google_compute_network.week_10.name

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  source_ranges = ["130.211.0.0/22",
   "35.191.0.0/16"]  # GCP health checker IPs
  target_tags   = ["web-server"]
}