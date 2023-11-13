resource "google_compute_instance_template" "my_template" {
    name        = "devops-template"
    machine_type = "e2-small"
    disk {
        source_image = google_compute_image.devs.self_link
        # source_image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
    network_interface {
        network = "default"
    }

    metadata = {
        ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
    }


    tags = ["http-server","https-server"]
}

# Target pool
resource "google_compute_target_pool" "devops_target_pool" {
  name = "devops-pool"
  region = var.gcp_region
  instances = [google_compute_instance.devops.self_link] 
}

resource "google_compute_image" "devs" {
  name = "devik"
  source_snapshot = google_compute_snapshot.devops_snapshot.self_link
}
