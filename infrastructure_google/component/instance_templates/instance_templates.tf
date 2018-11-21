resource "google_compute_instance_template" "instance_template" {
	name        = "${var.application}-instance-template"
	description = "This template is used to create app server instances."

	tags = ["http-server", "https-server"]

	labels = {
		environment = "${var.environment}"
	}

	instance_description = "description assigned to instances"
	machine_type         = "${var.machine_type}"
	can_ip_forward       = false

	scheduling {
		automatic_restart   = true
		on_host_maintenance = "MIGRATE"
	}

	// Create a new boot disk from an image
	disk {
		source_image = "${var.image}"
		auto_delete  = true
		boot         = true
	}

	network_interface {
		network = "default"
		
		access_config {
		  // Ephemeral IP
		}
	}
	
	lifecycle {
		create_before_destroy = true
	}
		
	metadata_startup_script = "${var.metadata_startup_script}"

	service_account {
		scopes = ["userinfo-email", "compute-ro", "storage-ro"]
	}
}
output instance_self_link {
	value = "${google_compute_instance_template.instance_template.self_link}"
}