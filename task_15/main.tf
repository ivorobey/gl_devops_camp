provider "google" {
  credentials = file("k8s-sparrow-main.json") #path tp your creds
  project     = "k8s-sparrow"     # your project id
  region      = "us-central1"
  zone        = "us-central1-c"
}
# Network
resource "google_compute_network" "own-network" {
  name                    = "own-network"
  auto_create_subnetworks = false
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.own-network.id
}
resource "google_service_networking_connection" "private_vpc_connection" {

  network                 = google_compute_network.own-network.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# Subnet
resource "google_compute_subnetwork" "own-subnetwork" {
  name          = "subnetwork"
  ip_cidr_range = "10.10.0.0/16"
  region        = "us-central1"
  network       = google_compute_network.own-network.id

}
# Instance Web
resource "google_compute_instance" "k8s" {
  name         = "k8s-server"
  machine_type = "e2-custom-4-16384"
  tags         = ["ssh", "http-server", "https-server"]
  metadata = {
    ssh-keys = "${var.ssh_username}:${file("/home/${var.ssh_username}/.ssh/id_rsa.pub")}"
  }
  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
      size  = "35"
    }
  }
  network_interface {
    network    = google_compute_network.own-network.id
    subnetwork = google_compute_subnetwork.own-subnetwork.id
    access_config {
    }
  }
  depends_on = [google_service_networking_connection.private_vpc_connection]
}


# Firewall
resource "google_compute_firewall" "allow-http" {
  name    = "allow-http"
  network = google_compute_network.own-network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "8080"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server","https-server"]
}

resource "google_compute_firewall" "allow-ssh" {
  name    = "allow-ssh"
  network = google_compute_network.own-network.name
  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["ssh"]
}
