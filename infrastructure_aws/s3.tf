resource "aws_s3_bucket" "bucket" {
  bucket = "${var.environment}-mybucket"

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm     = "AES256"
      }
    }
  }

  tags {
    Environment = "${var.environment}"
    Application = "${var.application}"
  }

  lifecycle_rule {
    id      = "tmp"
    enabled = true
    prefix  = ""

    expiration {
       days = 1
    }
  }
}