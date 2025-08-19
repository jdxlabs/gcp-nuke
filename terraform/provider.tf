terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 6.0" # prends la dernière stable
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
}
