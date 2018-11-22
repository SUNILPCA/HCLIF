resource "google_compute_instance" "instance" {
	name         = "${var.application}-instance"
	machine_type = "${var.machine_type}"
	tags         = ["${var.tag}"]

	boot_disk {
		initialize_params {
			image = "${var.image}"
		}
	}

	network_interface {
		network = "default"

		access_config {
		  // Ephemeral IP
		}
	}

	metadata_startup_script = "${var.metadata_startup_script}"

	service_account {
		scopes = ["https://www.googleapis.com/auth/compute.readonly"]
	}
}

output instance_self_link {
	value = "${google_compute_instance.instance.self_link}"
}