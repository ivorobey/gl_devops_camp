provider "google" {
  credentials = file("creds.json") #path tp your creds
  project     = "" # your project id
  region      = "us-central1"
  zone        = "us-central1-c"
}

# Instance Web
resource "google_compute_instance" "k8s" {
  name         = "k8s-server"
  machine_type = "e2-custom-4-8192"
  tags         = ["ssh", "http"]
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
    network    = google_compute_network.ownnetwork.id
    subnetwork = google_compute_subnetwork.ownsubnet.id
    access_config {
    }
  }
  depends_on = [google_service_networking_connection.private_vpc_connection]
}


# Network
resource "google_compute_network" "ownnetwork" {
  name                    = "ownnetwork"
  auto_create_subnetworks = false
}

resource "google_compute_global_address" "private_ip_address" {
  name          = "private-ip-address"
  purpose       = "VPC_PEERING"
  address_type  = "INTERNAL"
  prefix_length = 16
  network       = google_compute_network.ownnetwork.id
}
resource "google_service_networking_connection" "private_vpc_connection" {

  network                 = google_compute_network.ownnetwork.id
  service                 = "servicenetworking.googleapis.com"
  reserved_peering_ranges = [google_compute_global_address.private_ip_address.name]
}

# Subnet
resource "google_compute_subnetwork" "ownsubnet" {
  name          = "subnetwork"
  ip_cidr_range = "10.10.0.0/16"
  region        = "us-west1"
  network       = google_compute_network.ownnetwork.id

}

# Firewall
resource "google_compute_firewall" "tcp-ssh" {
  name    = "tcp-ssh"
  network = google_compute_network.ownnetwork.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http", "ssh"]
}