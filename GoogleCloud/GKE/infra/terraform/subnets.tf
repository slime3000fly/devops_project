resource "google_compute_subnetwork" "private" {
  name                     = "private"
  ip_cidr_range            = "10.0.0.0/19"
  region                   = var.gcp_region
  network                  = google_compute_network.main.id
  private_ip_google_access = true
  stack_type               = "IPV4_ONLY"

  secondary_ip_range {
    range_name    = "pods-ip-range"
    ip_cidr_range = "172.16.0.0/14"
  }

  secondary_ip_range {
    range_name    = "services-ip-range"
    ip_cidr_range = "172.20.0.0/18"
  }
}

# routing
resource "google_compute_route" "internet" {
  name             = "internet"
  dest_range       = "0.0.0.0/0"
  network          = google_compute_network.main.name
  next_hop_gateway = "default-internet-gateway"
}

# nat
resource "google_compute_router" "router" {
  name    = "router"
  region  = google_compute_subnetwork.private.region
  network = google_compute_network.main.id
}

resource "google_compute_address" "nat" {
  name         = "nat"
  address_type = "EXTERNAL"
  network_tier = "PREMIUM"
}

resource "google_compute_router_nat" "nat" {
  name                               = "nat"
  router                             = google_compute_router.router.name
  region                             = google_compute_router.router.region
  nat_ip_allocate_option             = "MANUAL_ONLY"
  source_subnetwork_ip_ranges_to_nat = "LIST_OF_SUBNETWORKS"
  nat_ips                            = [google_compute_address.nat.self_link]

  subnetwork {
    name                    = google_compute_subnetwork.private.self_link
    source_ip_ranges_to_nat = ["ALL_IP_RANGES"]
  }
}

# service account
resource "google_service_account" "kubernetes_node" {
  account_id = "kubernetes-node"
}