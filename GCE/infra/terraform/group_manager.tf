# resource "google_compute_instance_group_manager" "autobalancer" {
#     name             = "autobalancer"
#     base_instance_name = "devops"
#     target_size      = 1
#     zone             = var.gcp_zone

#     version {
#     instance_template = google_compute_instance_template.my_template.self_link
#     }

#     # Add existing machine
#     target_pools = [google_compute_target_pool.devops_target_pool.self_link]
# }

# resource "google_compute_autoscaler" "autoscaler" {
#     name = "my-autoscaler"
#     zone = var.gcp_zone
#     target = google_compute_instance_group_manager.autobalancer.id

#     autoscaling_policy {
#       max_replicas = 5
#       min_replicas = 1
#       cooldown_period = 60

#       metric {
#         name = "compute.googleapis.com/instance/disk/cpu-utilization"
#         target = 0.7
#         type = "DELTA_PER_MINUTE"
#       }
#     }
# }
