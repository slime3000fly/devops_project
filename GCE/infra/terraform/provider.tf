# Provider initialization for VirtualBox
provider "google" {
  credentials = file(var.gcp_key)
  project = var.gcp_project
  region = var.gcp_region
}

provider "google-beta" {
  credentials = file(var.gcp_key)
  project     = var.gcp_project
  region      = var.gcp_region
  zone        = var.gcp_zone
}
