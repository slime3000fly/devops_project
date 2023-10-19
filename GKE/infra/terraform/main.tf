resource "google_container_cluster" "DevOps_cluster" {
  name                     = "devops-clusetr"
  location                 = "europe-central2-a"
  remove_default_node_pool = true
  initial_node_count       = 1
  networking_mode          = "VPC_NATIVE"
  network                  = google_compute_network.main.self_link
  subnetwork               = google_compute_subnetwork.private.self_link
  node_config {
    machine_type    = "n1-standard-2"
    service_account = google_service_account.kubernetes_node.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
  }

  ip_allocation_policy {
    cluster_secondary_range_name  = "pods-ip-range"
    services_secondary_range_name = "services-ip-range"
  }


  monitoring_config {

    enable_components = ["SYSTEM_COMPONENTS"]

    managed_prometheus {
      enabled = true
    }
  }
}

