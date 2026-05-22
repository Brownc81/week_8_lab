resource "google_compute_instance_template" "north_camp" {
  name         = "north-camp"
  machine_type = "e2-medium"
  tags         = ["grafana"]

  disk {
    source_image = "rhel-cloud/rhel-9"
    auto_delete  = true
    disk_size_gb = 100
    boot         = true
  }

  metadata_startup_script = file("../startup.sh")

  network_interface {
    network = "default"

    access_config {
    // Leave empty = ephemeral external IP assigned automatically
    }

  }
}


  


resource "google_compute_instance_from_template" "north_camp_vm" {
  name = "north-camp-vm"
  zone = "us-central1-a"

  source_instance_template = google_compute_instance_template.north_camp.self_link_unique

    # 3. Choose 2 non-required arguments
    attached_disk {
        source      = google_compute_disk.vm_instances_bacfkend_template_group.self_link
        device_name = "grafana-disk"
    }
}

resource "google_compute_instance_group_manager" "north_camp_group" {
  name = "north-camp-group" #req

  base_instance_name        = "north-camp-group" #req
  zone                      = "us-central1-a"

  target_size               = 4

  version {
    instance_template = google_compute_instance_template.north_camp.self_link
    name              = "north-camp-primary"
  }

  standby_policy {
    initial_delay_sec           = 30
    mode                        = "MANUAL"
  }
  target_suspended_size         = 2
  target_stopped_size           = 1
}



#################### Firewall #######################

resource "google_compute_firewall" "north_camp_fw" {
  name    = "north-camp-fw"
  network = "default"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }

  # target_tags   = ["grafana"]
  # source_ranges = ["0.0.0.0/0"]  

  target_tags   = ["http-server"]
  source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
  
}

