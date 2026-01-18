# 0. Enable the Kubernetes API automatically
resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

# Modify your Cluster resource to wait for the API to be enabled
resource "google_container_cluster" "primary" {
  name     = "production-cluster"
  location = "us-central1-a"
  depends_on = [google_project_service.container]
}