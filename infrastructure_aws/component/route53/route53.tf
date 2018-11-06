resource "aws_route53_zone" "myzone" {
	count = "${var.count}"
	name = "${var.domain_name}"
}

resource "aws_route53_record" "www-a" {
	count = "${var.count}"
	zone_id = "${aws_route53_zone.myzone.zone_id}"
	name    = "${var.domain_name}"
	type    = "A"

	alias {
		name                   = "${var.cloudfront_website_domain_name}"
		zone_id                = "${var.cloudfront_website_hosted_zone}"
		evaluate_target_health = true
	}
}

resource "aws_route53_record" "apex" {
	count = "${var.count}"
	zone_id = "${aws_route53_zone.myzone.zone_id}"
	name    = "${var.domain_name}"
	type    = "A"

	alias {
		name                   = "${var.cloudfront_website_apex_domain_name}"
		zone_id                = "${var.cloudfront_website_apex_hosted_zone}"
		evaluate_target_health = true
	}
}