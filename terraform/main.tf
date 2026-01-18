provider "google" {
  project = "our-shield-480712-i3"
  region  = "us-central1"
}

# 1. Enable Kubernetes API automatically
resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

# 2. VPC Network
resource "google_compute_network" "vpc" {
  name                    = "gke-vpc"
  auto_create_subnetworks = "false"
}

resource "google_compute_subnetwork" "subnet" {
  name          = "gke-subnet"
  region        = "us-central1"
  network       = google_compute_network.vpc.name
  ip_cidr_range = "10.10.0.0/24"
}

# 3. GKE Cluster (Control Plane)
resource "google_container_cluster" "primary" {
  name     = "production-cluster"
  location = "us-central1-a"

  # Wait for API to be enabled
  depends_on = [google_project_service.container]

  # We create a default node pool with 1 node, then immediately delete it.
  # This satisfies the "initial_node_count > 0" requirement.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

  # Allow deletion for testing
  deletion_protection = false
}

# 4. Spot Node Pool (The Cheap Workers)
resource "google_container_node_pool" "primary_nodes" {
  name       = "spot-pool"
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  node_count = 2

  node_config {
    machine_type = "e2-small"
    preemptible  = true
    disk_type    = "pd-standard"
    disk_size_gb = 30

    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }
}