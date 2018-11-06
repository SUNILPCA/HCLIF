# Creating ELB
resource "aws_elb" "webserver_elb" {
	count = "${var.count}"
	name = "${var.environment}-elb"
	security_groups = ["${aws_security_group.elb-security_groups.id}"]
	availability_zones = ["${var.webserver_availability_zones}"]

	health_check {
		healthy_threshold = 2
		unhealthy_threshold = 2
		timeout = 3
		interval = 30
		target = "HTTP:${var.server_port}/"
	}

	# This adds a listener for incoming HTTP requests.
	listener {
		lb_port = 80
		lb_protocol = "http"
		instance_port = "${var.server_port}"
		instance_protocol = "http"
	}
}

# Security Group for ELB
resource "aws_security_group" "elb-security_groups" {
	count = "${var.count}"
	name = "${var.environment}-elb"

	# Allow all outbound
	egress {
		from_port = 0
		to_port = 0
		protocol = "-1"
		cidr_blocks = ["0.0.0.0/0"]
	}

	# Inbound HTTP from anywhere
	ingress {
		from_port = 80
		to_port = 80
		protocol = "tcp"
		cidr_blocks = ["0.0.0.0/0"]
	}
}

output "webserver_elb_name" {
	value = "${element(concat(aws_elb.webserver_elb.*.name, list("")),0)}"
}

output "webserver_elbelb_dns_name" {	
	value = "${element(concat(aws_elb.webserver_elb.*.dns_name, list("")),0)}"
}