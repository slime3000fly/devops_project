# locals {
#   network          = "default"
#   ssh_user         = "root"
#   private_key_path = "~/.ssh/id_rsa"
# }

# # Master server
# resource "google_compute_instance" "devops" {
#   name         = "devopsik"
#   machine_type = "e2-small"
#   zone         = var.gcp_zone  # chose zone
  
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

#   provisioner "remote-exec" {
#     inline = ["echo 'Wait until SSH is ready'"]

#     connection {
#       type        = "ssh"
#       user        = local.ssh_user
#       private_key = file(local.private_key_path)
#       host        = google_compute_instance.devops.network_interface.0.access_config.0.nat_ip
#     }
#   }

#   provisioner "local-exec" {
#     command = "ansible-playbook  -i ${google_compute_instance.devops.network_interface.0.access_config.0.nat_ip}, --private-key ${local.private_key_path} --ask-vault-pass ../main.yml"
#   }

#   tags = ["http-server","https-server"]
# }

# # # Create Snapshot
# # resource "google_compute_snapshot" "devops_snapshot" {
# #   name = "devops-snapshot"
# #   zone = var.gcp_zone
# #   chain_name = "snapshot-chain"
# #   storage_locations = [var.gcp_region]
# #   source_disk = google_compute_instance.devops.boot_disk[0].source
# # }

# # # Create image from snapshot
# # resource "google_compute_image" "my_image" {
# #   name         = "my-image"
# #   source_snapshot  = google_compute_snapshot.devops_snapshot.self_link
# #   family       = "my-image-family"
# #   description  = "My custom image based on a snapshot"
# # }