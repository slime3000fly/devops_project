# Master server
resource "google_compute_instance" "devops_server_master_node" {
  name         = "devops-master"
  machine_type = "e2-small"
  zone         = "europe-central2-a"  # chose zone
  
  network_interface {
    network = "default"
    access_config {}
  }

  boot_disk {
    initialize_params {
      image = "ubuntu-os-cloud/ubuntu-2004-lts"
    }
  }

  metadata = {
    ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
  }

  tags = ["http-server","https-server"]
}

# Working node
# resource "google_compute_instance" "devops_server_working_node" {
#   name         = "devops-working"
#   machine_type = "e2-small"
#   zone         = "europe-central2-a"  # chose zone
  
#   network_interface {
#     network = "default"
#     access_config {}
#   }

#   boot_disk {
#     initialize_params {
#       image = "ubuntu-os-cloud/ubuntu-2004-lts"
#     }
#   }

#   metadata = {
#     ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
#   }

#   tags = ["http-server","https-server"]
# }

# Get external ip address of master_node
resource "local_file" "external_ip" {
    content  = google_compute_instance.devops_server_master_node.network_interface.0.access_config.0.nat_ip
    filename = "ip.txt"
}

# Get external ip address working node
# resource "null_resource" "update_ip_file" {
#   triggers = {
#     ip_updated = local_file.external_ip.content
#   }

#   provisioner "local-exec" {
#     command = <<EOT
#       echo "\n${google_compute_instance.devops_server_working_node.network_interface.0.access_config.0.nat_ip}" >> ip.txt
#     EOT
#   }

#   depends_on = [local_file.external_ip]
# }