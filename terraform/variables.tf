variable "project_id" {
  description = "The GCP Project ID"
  type        = string
  default     = "our-shield-480712-i3"
}

variable "region" {
  description = "GCP Region for the cluster"
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP Zone for the nodes"
  type        = string
  default     = "us-central1-a"
}

variable "cluster_name" {
  description = "Name of the GKE cluster"
  type        = string
  default     = "production-cluster"
}