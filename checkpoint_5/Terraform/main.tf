terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.5.0"
    }
  }
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

resource "google_compute_subnetwork" "terraform-checkpoint5-subnet" {
  name          = "hannu-checkpoint5-subnet"
  ip_cidr_range = "10.0.1.0/24"
  region        = "us-central1"
  network       = google_compute_network.terraform-checkpoint5-vpc.id
}

resource "google_compute_network" "terraform-checkpoint5-vpc" {
  project                 = var.project
  name                    = "hannu-checkpoint5-vpc"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "terraform-checkpoint5-firewall" {
  name    = "hannu-checkpoint5-firewall"
  network = google_compute_network.terraform-checkpoint5-vpc.name

  allow {
    protocol = "tcp"
    ports    = ["80", "22"]
  }


  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["http-rule", "ssh-rule"]

}

resource "google_compute_instance" "terraform-checkpoint5-vm-instance" {
  name         = "hannu-checkpoint5-vm-instance"
  machine_type = "f1-micro"
  tags         = ["http-rule", "ssh-rule"]

  metadata_startup_script = file("startup.sh")

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = google_compute_network.terraform-checkpoint5-vpc.name
    subnetwork = google_compute_subnetwork.terraform-checkpoint5-subnet.name
    access_config {


    }

  }
}