output "hw_week10" {
  value = google_compute_network.week_10.name
}

output "instance_group" {
  value = google_compute_region_instance_group_manager.web.name
}

output "load_balancer_ip" {        # fixed typo
  value = "http://${google_compute_global_address.lb_ip.address}"
}