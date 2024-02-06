resource "google_storage_bucket" "web_static" {
  location = var.gcp_region
  name = "my_uniqe_devops_static_name"
  storage_class = "STANDARD"

  uniform_bucket_level_access = true
}

resource "null_resource" "copy_files" {
  triggers = {
    bucket_name = google_storage_bucket.web_static.name
  }

  provisioner "local-exec" {
    command = "gsutil -m cp -r ../website/* gs://${google_storage_bucket.web_static.name}/"
  }
}

resource "google_storage_bucket_iam_member" "public_access" {
  bucket = google_storage_bucket.web_static.name
  role   = "roles/storage.objectViewer"
  member = "allUsers"
}