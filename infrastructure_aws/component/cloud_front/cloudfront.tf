locals {
  s3_origin_id = "${var.environment}WebsiteS3"
  s3_apex_origin_id = "${var.environment}WebsiteS3Apex"
}

resource "aws_cloudfront_distribution" "website" {
	count			= "${var.count}"
	enabled 		= "${var.enabled}"
	is_ipv6_enabled = "${var.is_ipv6_enabled}"
	
	origin {
		domain_name = "${var.website_bucket_domain_name}"
		origin_id 	= "${local.s3_origin_id}"
	}
	#CNAME
	aliases = ["www.${var.domain_name}"]
	
	restrictions {
		geo_restriction {
			restriction_type = "${var.restriction_type}"
		}
	}
	
	default_cache_behavior {
		target_origin_id = "${local.s3_origin_id}"

		allowed_methods = ["GET", "HEAD"]
		cached_methods  = ["GET", "HEAD"]
		
		forwarded_values {
		  query_string = false

		  cookies {
			forward = "none"
		  }
		}

		viewer_protocol_policy = "redirect-to-https"
		min_ttl                = 0
		default_ttl            = 7200
		max_ttl                = 86400
	}
	
	viewer_certificate {
		cloudfront_default_certificate = true
	}
}

resource "aws_cloudfront_distribution" "website-apex" {
	count			= "${var.count}"
	enabled 		= "${var.enabled}"
	is_ipv6_enabled = "${var.is_ipv6_enabled}"
	
	origin {
		domain_name = "${var.website_apex_bucket_domain_name}"
		origin_id 	= "${local.s3_apex_origin_id}"
	}
	#CNAME
	aliases = ["${var.domain_name}"]
	
	restrictions {
		geo_restriction {
			restriction_type = "${var.restriction_type}"
		}
	}
	
	default_cache_behavior {
		target_origin_id = "${local.s3_apex_origin_id}"

		allowed_methods = ["GET", "HEAD"]
		cached_methods  = ["GET", "HEAD"]
		
		forwarded_values {
		  query_string = false

		  cookies {
			forward = "none"
		  }
		}

		viewer_protocol_policy = "redirect-to-https"
		min_ttl                = 0
		default_ttl            = 7200
		max_ttl                = 86400
	}
	
	viewer_certificate {
		cloudfront_default_certificate = true
	}
}

output cloudfront_website_domain_name{
	value = "${element(concat(aws_cloudfront_distribution.website.*.domain_name, list("")),0)}"
}

output cloudfront_website_hosted_zone{	
	value = "${element(concat(aws_cloudfront_distribution.website.*.hosted_zone_id, list("")),0)}"
}

output cloudfront_website_apex_domain_name{
	value = "${element(concat(aws_cloudfront_distribution.website-apex.*.domain_name, list("")),0)}"
}

output cloudfront_website_apex_hosted_zone{
	value = "${element(concat(aws_cloudfront_distribution.website-apex.*.hosted_zone_id, list("")),0)}"
}
