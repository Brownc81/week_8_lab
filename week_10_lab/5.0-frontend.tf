resource "google_compute_global_address" "lb_ip" {
  name = "web-lb-ip"
}


resource "google_compute_url_map" "web" {
  name            = "web-url-map"
  default_service = google_compute_backend_service.web.id
}

resource "google_compute_target_http_proxy" "web" {
  name    = "web-url-map"
  url_map = google_compute_url_map.web.id
}

resource "google_compute_global_forwarding_rule" "web" {
  name                  = "web-forwarding-rule"
  load_balancing_scheme = "EXTERNAL_MANAGED"
  ip_protocol           = "TCP"
  port_range            = "80"
  target                = google_compute_target_http_proxy.web.id
  ip_address            = google_compute_global_address.lb_ip.id
}