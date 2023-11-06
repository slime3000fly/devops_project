# resource "google_compute_instance_template" "my_template" {
#     name        = "devops-template"
#     machine_type = "e2-small"
#     disk {
#         source_image = google_compute_image.my_image.self_link
        
#     }
#     network_interface {
#         network = "default"
#     }

#     metadata = {
#         ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
#     }

#     provisioner "remote-exec" {
#         inline = ["echo 'Wait until SSH is ready'"]

#         connection {
#         type        = "ssh"
#         user        = local.ssh_user
#         private_key = file(local.private_key_path)
#         host        = google_compute_instance.devops.network_interface.0.access_config.0.nat_ip
#         }
#     }

#     provisioner "local-exec" {
#         command = "ansible-playbook  -i ${google_compute_instance.devops.network_interface.0.access_config.0.nat_ip}, --private-key ${local.private_key_path} --ask-vault-pass ../main.yml"
#     }

#     tags = ["http-server","https-server"]
# }

# # Target pool
# resource "google_compute_target_pool" "devops_target_pool" {
#   name = "devops-pool"
#   region = var.gcp_region
#   instances = [google_compute_instance.devops.self_link] 
# }

