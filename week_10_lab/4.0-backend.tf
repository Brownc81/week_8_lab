resource "google_compute_health_check" "backend" {
  name                = "load-balancer-health-check"
  timeout_sec         = 5
  check_interval_sec  = 10
  healthy_threshold   = 2
  unhealthy_threshold = 3

  http_health_check {
    port           = 80
    request_path   = "/healthz"
  }
}

resource "google_compute_backend_service" "web" {
  name                  = "web-backend"
  protocol              = "HTTP"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  port_name             = "http"
  timeout_sec           = 10
  health_checks         = [google_compute_health_check.backend.id]

  backend {
    group               = google_compute_region_instance_group_manager.web.instance_group
  }
}