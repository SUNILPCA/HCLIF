resource "google_compute_global_address" "external-address" {
	name = "${var.application}-tf-external-address"
}
resource "google_compute_health_check" "health-check" {
	name = "${var.application}-tf-health-check"

	http_health_check {}
}
resource "google_compute_backend_service" "www-service" {
	name     = "${var.application}-tf-www-service"
	protocol = "HTTP"

	backend {
		group = "${var.group_www}"
	}

	health_checks = ["${google_compute_health_check.health-check.self_link}"]
}
resource "google_compute_backend_service" "video-service" {
	name     = "${var.application}-tf-video-service"
	protocol = "HTTP"

	backend {
		group = "${var.group_video}"
	}

	health_checks = ["${google_compute_health_check.health-check.self_link}"]
}
resource "google_compute_url_map" "web-map" {
	name            = "${var.application}-tf-web-map"
	default_service = "${google_compute_backend_service.www-service.self_link}"

	host_rule {
		hosts        = ["*"]
		path_matcher = "tf-allpaths"
	}

	path_matcher {
		name            = "tf-allpaths"
		default_service = "${google_compute_backend_service.www-service.self_link}"

		path_rule {
			paths   = ["/video", "/video/*"]
			service = "${google_compute_backend_service.video-service.self_link}"
		}
	}
}
resource "google_compute_target_http_proxy" "http-lb-proxy" {
	name    = "${var.application}-tf-http-lb-proxy"
	url_map = "${google_compute_url_map.web-map.self_link}"
}

resource "google_compute_global_forwarding_rule" "default" {
	name       = "${var.application}-tf-http-content-gfr"
	target     = "${google_compute_target_http_proxy.http-lb-proxy.self_link}"
	ip_address = "${google_compute_global_address.external-address.address}"
	port_range = "80"
}
resource "google_compute_firewall" "default" {
	name    = "${var.application}-tf-www-firewall-allow-internal-only"
	network = "default"

	allow {
		protocol = "tcp"
		ports    = ["80"]
	}

	source_ranges = ["130.211.0.0/22", "35.191.0.0/16"]
	target_tags   = ["http-tag"]
}

output "application_public_ip" {
	value = "${google_compute_global_forwarding_rule.default.ip_address}"
}