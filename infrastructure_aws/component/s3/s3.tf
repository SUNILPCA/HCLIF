#Creating S3 bucket for resource
resource "aws_s3_bucket" "website" {
	count  = "${var.count}"
	bucket = "${var.domain_name}-website"
	acl    = "public-read"
	policy = "${file("./component/s3/s3_public.json")}"	
}

#Creating empty S3 bucket for website redirect
resource "aws_s3_bucket" "apex" {
    count  = "${var.count}"
	bucket = "${var.domain_name}-redirect"
	acl    = "public-read"
	website {
		redirect_all_requests_to = "https://www.${var.domain_name}"
	}
}

output website_bucket_domain_name {
	value = "${element(concat(aws_s3_bucket.website.*.bucket_domain_name, list("")),0)}"
}

output website_apex_bucket_domain_name {
	value = "${element(concat(aws_s3_bucket.apex.*.bucket_domain_name, list("")),0)}"
}