resource "aws_sns_topic" "sns_topic" {
	name = "${var.application}_sns_topic"
}