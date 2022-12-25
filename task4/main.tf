provider "google" {
  credentials = file("creds.json") #path tp your creds
  project     = "" # your project id
  region      = "us-central1"
  zone        = "us-central1-c"
}

resource "google_compute_instance" "vm_instance" {
  name         = "lamp"
  machine_type = "e2-micro"

  tags = ["http-server", "https-server"]

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
      size  = 10
    }
  }

  network_interface {
    network = google_compute_network.vpc_network1.name
    access_config {
    }
  }

  metadata_startup_script = file("lamp.sh")
}

resource "google_compute_network" "vpc_network1" {
  name = "vpc-network1"
}

resource "google_compute_firewall" "ssh" {
  name          = "allow-ssh"
  network       = google_compute_network.vpc_network1.name
  source_ranges = ["0.0.0.0/0"]
  direction     = "INGRESS"
  priority      = "65534"

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}

resource "google_compute_firewall" "http" {
  name          = "allow-http"
  network       = google_compute_network.vpc_network1.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-server"]
  direction     = "INGRESS"
  priority      = "1000"

  allow {
    protocol = "tcp"
    ports    = ["80"]
  }
}

resource "google_compute_firewall" "https" {
  name          = "allow-https"
  network       = google_compute_network.vpc_network1.name
  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["https-server"]
  direction     = "INGRESS"
  priority      = "1000"

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }
}
