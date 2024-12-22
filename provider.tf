provider "google" {
  project = var.project_id
  region  = var.region
}

terraform {
  backend "gcs" {
    bucket = "mfrigabucket"
    prefix = "terraform/state"
  }
} 