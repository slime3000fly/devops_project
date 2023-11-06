resource "google_compute_instance_template" "my_template" {
    name        = "my-template"

    # In this section, you can define the properties of your instance template
    machine_type = "e2-small"
    disk {
        source_snapshot  = google_compute_snapshot.devops_snapshot.self_link
    }
    network_interface {
        network = "default"
    }

    metadata = {
        ssh-keys = "root:${file("~/.ssh/id_rsa.pub")}"
    }

    tags = ["http-server","https-server"]
}
