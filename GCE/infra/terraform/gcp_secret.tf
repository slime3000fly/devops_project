variable "ansible_password" {
  type = string
}

resource "google_secret_manager_secret" "ansible_password" {
  secret_id = "ansible"

  replication {
    auto {}
  }
}

resource "google_secret_manager_secret_version" "ansible_secret" {
  secret = google_secret_manager_secret.ansible_password.name
  secret_data = var.ansible_password
}