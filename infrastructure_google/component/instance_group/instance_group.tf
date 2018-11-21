#resource "google_compute_instance_group" "group" {
	#count		= "${length(var.zones)}"
#	name        = "${var.application}-group"
#	description = "Terraform test instance group name as ${var.application}"
	#zone        = "${var.zones[count.index]}"
	#network     = "${google_compute_network.network.self_link}"
#	named_port {
#		name = "http"
#		port = "80"
#	}
	
#}

#resource "google_compute_network" "network" {
#	name = "${var.application}-network"
#	auto_create_subnetworks = "${var.auto_create_subnetworks}"
#}

#output instance_group_self_link {
#	value = "${google_compute_instance_group.group.self_link}"
#}

resource "google_compute_instance_group_manager" "group_manager" {
	count = "${length(var.zone)}"

	name               = "${var.application}-${count.index}"
	instance_template  = "${var.instance_self_link}"
	base_instance_name = "${var.application}-${count.index}"
	zone               = "${var.zone[count.index]}"
	target_size        = 1
}

output instance_group_self_link {
	value = "${google_compute_instance_group_manager.group_manager.*.self_link}"
}