resource "google_compute_health_check" "app" {
  name                = "http-health-check"
  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    port         = 80
    request_path = "/healthz"
  }
}

resource "google_compute_region_instance_group_manager" "web" {
  name   = "my-igm"
  region = "us-central1"

  base_instance_name = "web"
  
  version {
    instance_template = google_compute_region_instance_template.week_10.id
  }

  named_port {
    name = "http"
    port = 80
  }

  auto_healing_policies {
    health_check      = google_compute_health_check.backend.id
    initial_delay_sec = 300
  }
}

resource "google_compute_region_autoscaler" "web_autoscaler" {
  name   = "web-autoscaler"
  region = "us-central1"
  target = google_compute_region_instance_group_manager.web.id

  autoscaling_policy {
    max_replicas    = 6
    min_replicas    = 4
    cooldown_period = 60

    cpu_utilization {
      target = 0.5
    }
  }
}
