# Provider initialization for VirtualBox
provider "google" {
  credentials = file(var.gcp_key)
  project = var.gcp_project
  region = var.gcp_region
}

# provider "google-beta" {
#   project = var.gcp_project
#   region  = var.gcp_region
# }

# terraform {
#   required_providers {
#     google = {
#       source  = "hashicorp/google"
#       version = "~> 4.42"
#     }
#     google-beta = {
#       source  = "hashicorp/google-beta"
#       version = "~> 4.42"
#     }
#   }

#   required_version = "> 1.0.0"
# }