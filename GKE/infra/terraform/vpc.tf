resource "google_compute_network" "main" {
  name                            = "main"
  routing_mode                    = "REGIONAL"
  auto_create_subnetworks         = false

  depends_on = [
    google_project_service.api
  ]
}