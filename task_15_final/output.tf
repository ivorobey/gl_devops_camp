output "ip" {
  value = google_compute_instance.k8s.network_interface[0].access_config[0].nat_ip
}

output "private_ip_sql" {
  value = google_sql_database_instance.instance.private_ip_address
}
